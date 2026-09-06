import QtQuick
import Quickshell
import Quickshell.Io
import "WidgetState.js" as StateModel

// Widget entries can be deleted/recreated by a bar's enable switch.
// Persist only this widget's settings, never the surrounding bar layout.
Item {
    id: root
    visible: false
    required property string widgetId
    required property var inputSettings
    required property var keys
    property var defaults: ({})
    property var cached: ({})
    property bool ready: false
    property string lastSaved: ""
    readonly property string stateDir: (Quickshell.env("XDG_STATE_HOME")
        || Quickshell.env("HOME") + "/.local/state") + "/omarchy/atelier-widgets"
    readonly property var effective: Object.assign({}, defaults, cached, pick(inputSettings))

    function pick(value) {
        return StateModel.pick(value, keys);
    }

    function value(key, fallback) {
        var result = effective[key];
        return result === undefined || result === null ? fallback : result;
    }

    function load(raw) {
        ready = false;
        try {
            cached = StateModel.decode(raw, keys);
        } catch (error) {
            console.warn(widgetId + ": cannot parse saved settings: " + error);
            // Do not replace an unreadable recovery file.
            return;
        }
        lastSaved = raw;
        ready = true;
        save();
    }

    function save() {
        if (!ready) return;
        var next = StateModel.merge(cached, inputSettings, keys);
        if (Object.keys(next).length === 0) return;
        var raw = JSON.stringify({version: 1, settings: next}, null, 2) + "\n";
        if (raw === lastSaved) return;
        cached = next;
        lastSaved = raw;
        stateFile.setText(raw);
    }

    onInputSettingsChanged: save()

    Process {
        command: ["mkdir", "-p", root.stateDir]
        running: true
        onExited: function(exitCode) {
            if (exitCode === 0)
                stateFile.path = root.stateDir + "/" + root.widgetId + ".json";
            else console.warn(root.widgetId + ": cannot create settings directory");
        }
    }

    FileView {
        id: stateFile
        atomicWrites: true
        // Tiny settings snapshots must finish before a widget can be disabled.
        blockWrites: true
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: root.load(text())
        onLoadFailed: function(error) {
            if (error === FileViewError.FileNotFound) root.load("");
            else {
                root.ready = false;
                console.warn(root.widgetId + ": cannot read settings (" + error + ")");
            }
        }
        onSaveFailed: function(error) {
            root.lastSaved = "";
            console.warn(root.widgetId + ": cannot save settings (" + error + ")");
        }
    }
}
