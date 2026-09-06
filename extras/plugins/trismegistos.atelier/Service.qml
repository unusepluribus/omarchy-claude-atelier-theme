import QtQuick
import Quickshell.Io
import qs.Commons

Item {
  id: root
  property var shell: null
  readonly property bool active: Color.pick("atelier.enabled", "false") === "true"

  Binding {
    target: Style
    property: "fontFamily"
    when: root.active
    value: Color.pick("atelier.ui-font", "Adwaita Sans")
    restoreMode: Binding.RestoreBindingOrValue
  }

  IpcHandler {
    target: "claude-atelier"
    function status(): string {
      return JSON.stringify({active: root.active, shellFont: Style.font.family,
        codeFontChanged: false});
    }
  }
}
