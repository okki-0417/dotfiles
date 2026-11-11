// profile.json から Terminal.app のプロファイル（.terminal ファイル）を生成する。
// 使い方: osascript -l JavaScript build.js <profile.json> <出力先.terminal>
//
// .terminal は plist で、色とフォントは NSColor / NSFont をアーカイブしたバイナリになる。
// 手で編集できないので、profile.json（色は #rrggbb）を正としてここで変換する。
ObjC.import("AppKit");

function run(argv) {
  const [src, out] = argv;
  if (!src || !out) throw new Error("usage: build.js <profile.json> <out.terminal>");

  const json = $.NSString.stringWithContentsOfFileEncodingError(src, $.NSUTF8StringEncoding, null);
  const p = JSON.parse(json.js);

  const archive = (obj) =>
    $.NSKeyedArchiver.archivedDataWithRootObjectRequiringSecureCodingError(obj, false, null);

  const color = (hex) => {
    const m = /^#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/i.exec(hex);
    if (!m) throw new Error("色は #rrggbb で書く: " + hex);
    const [r, g, b] = m.slice(1).map((x) => parseInt(x, 16) / 255);
    return $.NSColor.colorWithSRGBRedGreenBlueAlpha(r, g, b, 1);
  };

  const value = (v) => {
    if (typeof v === "boolean") return $.NSNumber.numberWithBool(v);
    if (typeof v === "number") return $.NSNumber.numberWithDouble(v);
    if (typeof v === "string") return $(v);
    throw new Error("settings に使える値は真偽値・数値・文字列のみ: " + JSON.stringify(v));
  };

  const d = $.NSMutableDictionary.dictionary;
  d.setObjectForKey($(p.name), "name");
  d.setObjectForKey($("Window Settings"), "type");
  d.setObjectForKey($("2.09"), "ProfileCurrentVersion");

  const font = $.NSFont.fontWithNameSize(p.font.name, p.font.size);
  if (font.isNil()) throw new Error("フォントが見つからない: " + p.font.name);
  d.setObjectForKey(archive(font), "Font");

  for (const [key, hex] of Object.entries(p.colors)) d.setObjectForKey(archive(color(hex)), key);
  for (const [key, v] of Object.entries(p.settings)) d.setObjectForKey(value(v), key);

  if (!d.writeToURLError($.NSURL.fileURLWithPath(out), null)) throw new Error("書き込みに失敗: " + out);
  return p.name; // 呼び出し側（apply.sh）が既定のプロファイルに設定するために使う
}
