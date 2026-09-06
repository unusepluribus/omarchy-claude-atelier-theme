function pick(value, keys) {
    var result = {};
    if (!value || typeof value !== "object" || Array.isArray(value)) return result;
    for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        if (value[key] !== undefined && value[key] !== null) result[key] = value[key];
    }
    return JSON.parse(JSON.stringify(result));
}

function merge(cached, input, keys) {
    return Object.assign({}, pick(cached, keys), pick(input, keys));
}

function decode(raw, keys) {
    if (!raw) return {};
    var document = JSON.parse(raw);
    if (document.version !== 1 || !document.settings || typeof document.settings !== "object"
            || Array.isArray(document.settings))
        throw new Error("Unsupported or invalid saved widget settings");
    return pick(document.settings, keys);
}

if (typeof module !== "undefined") module.exports = {pick: pick, merge: merge, decode: decode};
