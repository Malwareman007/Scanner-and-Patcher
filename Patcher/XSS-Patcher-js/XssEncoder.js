var $namespace = function (fullNS) {
    var nsArray = fullNS.split('.');
    var sEval = "";
    var sNS = "";
    for (var i = 0; i < nsArray.length; i++) {
        if (i != 0) sNS += ".";
        sNS += nsArray[i];
        sEval += "if (typeof(" + sNS + ") == 'undefined') " + sNS + " = new Object();"
    }
    if (sEval != "") eval(sEval);
};

$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.JSONEncoder = function () {
    var _super = new com.venscor.codesec.xsspatcher.encoder.AbstractEncoder();
    var encodeCharsets = new Array('<', '&', '>', '(', ')', '\\');
    return {
        encode: _super.encode,
        encodeCharacter: function (c) {
            if (encodeCharsets.indexOf(c) > -1) {
                var hex = com.venscor.codesec.xsspatcher.encoder.Utils.getHex(c);
                return "&#x" + hex + ";";
            }
            return "" + c;
        }
    }
}


$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.JsUrlEncoder = function () {
    var urlEncoder = new com.venscor.codesec.xsspatcher.encoder.URLEncoder();
    var javascriptEncoder = new com.venscor.codesec.xsspatcher.encoder.JavascriptEncoder();
    return {
        encode: function (sInput) {
            var tmp = urlEncoder.encode(sInput);
            if (tmp == null) {
                return "";
            }
            return javascriptEncoder.encode(sInput);
        }
    }
}


$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.JsHtmlAttributeEncoder = function () {
    var htmlAttributeEncoder = new com.venscor.codesec.xsspatcher.encoder.HtmlAttributeEncoder();
    var javascriptEncoder = new com.venscor.codesec.xsspatcher.encoder.JavascriptEncoder();
    return {
        encode: function (sInput) {
            var tmp = htmlAttributeEncoder.encode(sInput);
            if (tmp == null) {
                return "";
            }
            return javascriptEncoder.encode(sInput);
        }
    }

}


$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.JsHtmlEntityEncoder = function () {
    var htmlEntityEncoder = new com.venscor.codesec.xsspatcher.encoder.HtmlEntityEncoder();
    var javascriptEncoder = new com.venscor.codesec.xsspatcher.encoder.JavascriptEncoder();

    return {
        encode: function (sInput) {
            var tmp = htmlEntityEncoder.encode(sInput);
            if (tmp == null) {
                return "";
            }
            return javascriptEncoder.encode(tmp);
        }
    }
}


$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.JsCSSEncoder = function () {

    var cssEncoder = new com.venscor.codesec.xsspatcher.encoder.CSSEncoder();
    var javascriptEncoder = new com.venscor.codesec.xsspatcher.encoder.JavascriptEncoder();

    return {
        encode: function (sInput) {
            var tmp = cssEncoder.encode(sInput);
            if (tmp == null) {
                return "";
            }
            return javascriptEncoder.encode(tmp);
        }
    }
}

$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.URLEncoder = function () {
    var immuneCharsets = "#&-./0123456789=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~";

    return {
        encode: function (sInput) {
            var out = '';
            if (sInput == null) {
                return "";
            }
            var index = 0;
            if (sInput.startsWith("http://")) {
                index = 7;
                out += "http://";
            } else if (sInput.startsWith("https://")) {
                index = 8;
                out += "https://";
            }
            for (; index < sInput.length; index++) {
                var c = sInput.charAt(index);
                out += this.encodeCharacter(c);
            }
            return out;
        },
        encodeCharacter: function (c) {
            if (immuneCharsets.indexOf(c) > -1) {
                return "" + c;
            }
            var hex = com.venscor.codesec.xsspatcher.encoder.Utils.getHex(c);
            return "%" + hex;
        }
    }
}


/*
 * Unquated JS encode
 *
 * */
$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.UnquatedJavascriptEncoder = function () {
    var _super = new com.venscor.codesec.xsspatcher.encoder.AbstractEncoder();
    var immuneCharsets = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "x");

    return {
        encode: _super.encode,
        encodeCharacter: function (c) {
            if (immuneCharsets.indexOf(c) > -1) {
                return "" + c;
            }
            var hex = com.venscor.codesec.xsspatcher.encoder.Utils.getHex(c);
            if (c.charCodeAt() < 256) {
                var pad = "00".substr(hex.length);
                return "\\x" + pad + hex;
            }
            pad = "0000".substr(hex.length);
            return "\\u" + pad + hex;
        }
    }
}


/*
 * JS encode
 *
 * */
$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.JavascriptEncoder = function () {
    var _super = new com.venscor.codesec.xsspatcher.encoder.AbstractEncoder();
    var encodeCharsets = new Array('\"', '&', '\'', '/', '\\', '\u2028', '\u2029', '\r', '\n', '\b', '\f');

    return {
        encode: _super.encode,
        encodeCharacter: function (c) {
            if (encodeCharsets.indexOf(c) > -1) {
                if (c == "/") {
                    return "\\/";
                }
                if (c == "\\") {
                    return "\\\\";
                }
                var hex = com.venscor.codesec.xsspatcher.encoder.Utils.getHex(c);
                if (c.charCodeAt() < 256) {
                    var pad = "00".substr(hex.length);
                    return "\\x" + pad + hex;
                } else {
                    pad = "0000".substr(hex.length);
                    return "\\u" + pad + hex;
                }
            }
            return "" + c;
        }
    }

}


/*
 *
 * CSS Encode
 * */
$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.CSSEncoder = function () {
    var _super = new com.venscor.codesec.xsspatcher.encoder.AbstractEncoder();
    var encodeCharsets = new Array('\"', '\'', '\\', '<', '&', '(', ')', '/', '>', '\u007f', '\u2028', '\u2029');
    return {
        encode: _super.encode,
        encodeCharacter: function (c) {
            var hex = com.venscor.codesec.xsspatcher.encoder.Utils.getHex(c);
            if (encodeCharsets.indexOf(c) > -1) {
                return "\\" + hex + " ";
            }
            return "" + c;
        }
    }
}


/*
 *
 * HTML Attribute encode
 *
 * */
$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.HtmlAttributeEncoder = function () {
    var _super = new com.venscor.codesec.xsspatcher.encoder.AbstractEncoder();
    var encodeCharsets = new Array('\u0009', '\n', '\u000C', '\r', '\u0020', '&', '<', '>', '\"', '\'', '/', '=', '`', '\u0085', '\u2028', '\u2029');

    return {
        encode: _super.encode,
        encodeCharacter: function (c) {
            var hex = com.venscor.codesec.xsspatcher.encoder.Utils.getHex(c);
            if (encodeCharsets.indexOf(c) > -1) {
                return "&#x" + hex + ";"
            }
            return c;
        }
    }
}


/*
 *
 *
 * HTML Entity Encoder
 *
 * */
$namespace('com.venscor.codesec.xsspatcher.encoder');
com.venscor.codesec.xsspatcher.encoder.HtmlEntityEncoder = function () {
    var _super = new com.venscor.codesec.xsspatcher.encoder.AbstractEncoder();
    var encodeCharsets = new Array('&', '<', '>', '\'', '\"', "/");
    return {


        encode: _super.encode,

        /**
         * Default implementation that should be overridden in specific codecs.
         * @param c
         *              the Character to encode
         * @return
         *              the encoded Character
         */
        encodeCharacter: function (c) {
            var hex = com.venscor.codesec.xsspatcher.encoder.Utils.getHex(c);
            if (encodeCharsets.indexOf(c) > -1) {
                return "&#x" + hex + ";"
            }
            return c;
        }
    };
};


/*
 *
 * parent encoder
 *
 *
 */
$namespace('com.venscor.codesec.xsspatcher.encoder');
com.venscor.codesec.xsspatcher.encoder.AbstractEncoder = function () {
    return {

        encode: function (sInput) {
            var out = '';
            for (var i = 0; i < sInput.length; i++) {
                var c = sInput.charAt(i);
                out += this.encodeCharacter(c);
            }
            return out;
        },

        encodeCharacter: function (c) {
            return c;
        }
    };
};


$namespace("com.venscor.codesec.xsspatcher.encoder.Utils");
com.venscor.codesec.xsspatcher.encoder.Utils.getHex = function (c) {
    return c.charCodeAt(0).toString(16);
}

$namespace("com.venscor.codesec.xsspatcher.encoder");
com.venscor.codesec.xsspatcher.encoder.XSSEncoder = function () {
    var _htmlEntityEncoder = new com.venscor.codesec.xsspatcher.encoder.HtmlEntityEncoder();
    var _htmlAttributeEncoder = new com.venscor.codesec.xsspatcher.encoder.HtmlAttributeEncoder();
    var _cssEncoder = new com.venscor.codesec.xsspatcher.encoder.CSSEncoder();
    var _urlEncoder = new com.venscor.codesec.xsspatcher.encoder.URLEncoder();
    var _jsonEncoder = new com.venscor.codesec.xsspatcher.encoder.JSONEncoder();
    var _javascriptEncoder = new com.venscor.codesec.xsspatcher.encoder.JavascriptEncoder();
    var _unquatedJavascriptEncoder = new com.venscor.codesec.xsspatcher.encoder.UnquatedJavascriptEncoder();

    var _jsHtmlEntityEncoder = new com.venscor.codesec.xsspatcher.encoder.JsHtmlEntityEncoder();
    var _jsHtmlAttributeEncoder = new com.venscor.codesec.xsspatcher.encoder.JsHtmlAttributeEncoder();
    var _jsCSSEncoder = new com.venscor.codesec.xsspatcher.encoder.JsCSSEncoder();
    var _jsUrlEncoder = new com.venscor.codesec.xsspatcher.encoder.JsUrlEncoder();


    return {
        encodeForHtmlEntity: function (sInput) {
            return !sInput ? null : _htmlEntityEncoder.encode(sInput);
        },
        encodeForHtmlAttribute: function (sInput) {
            return !sInput ? null : _htmlAttributeEncoder.encode(sInput);
        },
        encodeForCSS: function (sInput) {
            return !sInput ? null : _cssEncoder.encode(sInput);
        },
        encodeForUrl: function (sInput) {
            return !sInput ? null : _urlEncoder.encode(sInput);
        },
        encodeForJSON: function (sInput) {
            return !sInput ? null : _jsonEncoder.encode(sInput);
        },
        encodeForJavascript: function (sInput) {
            return !sInput ? null : _javascriptEncoder.encode(sInput);
        },
        encodeForUnquatedJavascript: function (sInput) {
            return !sInput ? null : _unquatedJavascriptEncoder.encode(sInput);
        },


        encodeForJsHtmlEntity: function (sInput) {
            return !sInput ? null : _jsHtmlEntityEncoder.encode(sInput);
        },
        encodeForJsHtmlAttribute: function (sInput) {
            return !sInput ? null : _jsHtmlAttributeEncoder.encode(sInput);
        },
        encodeForJsCSS: function (sInput) {
            return !sInput ? null : _jsCSSEncoder.encode(sInput);
        },
        encodeForJsUrl: function (sInput) {
            return !sInput ? null : _jsUrlEncoder.encode(sInput);
        }
    }
}

var $XSSEncoder = new com.venscor.codesec.xsspatcher.encoder.XSSEncoder();



