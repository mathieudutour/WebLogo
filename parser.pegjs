
start
  = __ program:Program __ { return program; }

/* ===== A.1 Lexical Grammar ===== */

SourceCharacter
  = .

WhiteSpace "whitespace"
  = [\t\v\f \u00A0\uFEFF]
  / Zs

LineTerminator
  = [\n\r\u2028\u2029]

LineTerminatorSequence "end of line"
  = "\n"
  / "\r\n"
  / "\r"
  / "\u2028" // line separator
  / "\u2029" // paragraph separator

Comment "comment"
  = SingleLineComment

SingleLineComment
  = ";" (!LineTerminator SourceCharacter)*

Identifier "identifier"
  = !ReservedWord !Variable !(NumericLiteral) name:IdentifierName { return name; }

IdentifierName "identifier"
  = start:IdentifierStart parts:IdentifierPart+{
      return start + parts.join("");
    }

IdentifierStart
  = UnicodeLetter
  / [.=*!<>:#+/%$_^'&]
  / "-" {return "_";}

IdentifierPart
  = IdentifierStart
  / "?" {return "";}

UnicodeLetter
  = Lu
  / Ll
  / Lt
  / Lm
  / Nl

UnicodeCombiningMark
  = Mn
  / Mc

UnicodeDigit
  = Nd

UnicodeConnectorPunctuation
  = Pc

ReservedWord
  = Keyword
  / NullLiteral
  / BooleanLiteral

Keyword
  = (
        "globals"
      / "breed"
      / "turtles-own"
      / "patches-own"
      / "to"
      / "to-report"
      / "end"
      / "extensions"
      / "__includes"
    )
    !IdentifierPart

Variable
  =     "breed" 		!IdentifierPart { return "breed"; }
      / "color" 		!IdentifierPart { return "color"; }
      / "heading" 		!IdentifierPart { return "heading"; }
      / "hidden?" 		!IdentifierPart { return "hidden"; }
      / "label"			!IdentifierPart { return "label"; }
      / "label-color"	!IdentifierPart { return "label_color"; }
      / "pen-mode"		!IdentifierPart { return "pen_mode"; }
      / "pen-size"		!IdentifierPart { return "pen_size"; }
      / "shape"			!IdentifierPart { return "shape"; }
      / "size"			!IdentifierPart { return "size"; }
      / "who"			!IdentifierPart { return "who"; }
      / "xcor"			!IdentifierPart { return "xcor"; }
      / "ycor"			!IdentifierPart { return "ycor"; }
      / "pcolor"		!IdentifierPart { return "color"; }
      / "plabel"		!IdentifierPart { return "label"; }
      / "plabel-color"	!IdentifierPart { return "label_color"; }
      / "pxcor"			!IdentifierPart { return "xcor"; }
      / "pycor"			!IdentifierPart { return "ycor"; }
      / "end1"			!IdentifierPart { return "end1"; }
      / "end2"			!IdentifierPart { return "end2"; }
      / "thickness"		!IdentifierPart { return "thickness"; }
      / "tie-mode"		!IdentifierPart { return "tie_mode"; }
      / "e"				!IdentifierPart { return "Math.E"; }
      / "pi" 			!IdentifierPart { return "Math.PI"; }
      / "black" 		!IdentifierPart { return "new Color('black')"; }
      / "gray" 			!IdentifierPart { return "new Color('gray')"; }
      / "white" 		!IdentifierPart { return "new Color('white')"; }
      / "red" 			!IdentifierPart { return "new Color('red')"; }
      / "orange" 		!IdentifierPart { return "new Color('orange')"; }
      / "brown" 		!IdentifierPart { return "new Color('brown')"; }
      / "yellow" 		!IdentifierPart { return "new Color('yellow')"; }
      / "green" 		!IdentifierPart { return "new Color('green')"; }
      / "lime" 			!IdentifierPart { return "new Color('lime')"; }
      / "turquoise" 	!IdentifierPart { return "new Color('turquoise')"; }
      / "cyan" 			!IdentifierPart { return "new Color('cyan')"; }
      / "sky" 			!IdentifierPart { return "new Color('sky')"; }
      / "blue" 			!IdentifierPart { return "new Color('blue')"; }
      / "violet" 		!IdentifierPart { return "new Color('violet')"; }
      / "magenta" 		!IdentifierPart { return "new Color('magenta')"; }
      / "pink" 			!IdentifierPart { return "new Color('pink')"; }



Literal
  = NullLiteral
  / BooleanLiteral
  / value:NumericLiteral {
      return value;
    }
  / value:StringLiteral {
      
        return value;
    }

NullLiteral
  = NullToken { return { type: "NullLiteral" }; }

BooleanLiteral
  = TrueToken  { return { type: "BooleanLiteral", value: true  }; }
  / FalseToken { return { type: "BooleanLiteral", value: false }; }

NumericLiteral "number"
  = literal:(DecimalLiteral) !IdentifierStart {
      return literal;
    }

DecimalLiteral
  = parts:(DecimalIntegerLiteral "." DecimalDigits? ExponentPart?) {
      return parseFloat(parts);
    }
  / parts:("." DecimalDigits ExponentPart?)     { return parseFloat(parts); }
  / parts:(DecimalIntegerLiteral ExponentPart?) { return parseFloat(parts); }

DecimalIntegerLiteral
  = "0" / first:NonZeroDigit last:DecimalDigits? {return ""+first+last;}

DecimalDigits
  = digits:DecimalDigit+ {return digits.join("");}

DecimalDigit
  = [0-9]

NonZeroDigit
  = [1-9]

ExponentPart
  = ExponentIndicator SignedInteger

ExponentIndicator
  = [eE]

SignedInteger
  = [-+]? DecimalDigits

StringLiteral "string"
  = parts:('"' DoubleStringCharacters? '"' / "'" SingleStringCharacters? "'") {
      return parts[1];
    }

DoubleStringCharacters
  = chars:DoubleStringCharacter+ { return chars.join(""); }

SingleStringCharacters
  = chars:SingleStringCharacter+ { return chars.join(""); }

DoubleStringCharacter
  = !('"' / "\\" / LineTerminator) char_:SourceCharacter { return char_;     }
  / "\\" sequence:EscapeSequence                         { return sequence;  }
  / LineContinuation

SingleStringCharacter
  = !("'" / "\\" / LineTerminator) char_:SourceCharacter { return char_;     }
  / "\\" sequence:EscapeSequence                         { return sequence;  }
  / LineContinuation

LineContinuation
  = "\\" sequence:LineTerminatorSequence { return sequence; }

EscapeSequence
  = CharacterEscapeSequence
  / "0" !DecimalDigit { return "\0"; }

CharacterEscapeSequence
  = SingleEscapeCharacter
  / NonEscapeCharacter

SingleEscapeCharacter
  = char_:['"\\bfnrtv] {
      return char_
        .replace("b", "\b")
        .replace("f", "\f")
        .replace("n", "\n")
        .replace("r", "\r")
        .replace("t", "\t")
        .replace("v", "\x0B") // IE does not recognize "\v".
    }

NonEscapeCharacter
  = (!EscapeCharacter / LineTerminator) char_:SourceCharacter { return char_; }

EscapeCharacter
  = SingleEscapeCharacter
  / DecimalDigit
  / "x"
  / "u"

/* Tokens */

BreakToken      = "break"            !IdentifierPart
CaseToken       = "case"             !IdentifierPart
CatchToken      = "catch"            !IdentifierPart
ContinueToken   = "continue"         !IdentifierPart
DebuggerToken   = "debugger"         !IdentifierPart
DefaultToken    = "default"          !IdentifierPart
DeleteToken     = "delete"           !IdentifierPart { return "delete"; }
DoToken         = "do"               !IdentifierPart
ElseToken       = "else"             !IdentifierPart
FalseToken      = "false"            !IdentifierPart
FinallyToken    = "finally"          !IdentifierPart
ForToken        = "for"              !IdentifierPart
ProcedureToken  = "to"               !IdentifierPart
ProcedureEndToken= "end"             !IdentifierPart
GetToken        = "get"              !IdentifierPart
IfToken         = "if"               !IdentifierPart
InstanceofToken = "instanceof"       !IdentifierPart { return "instanceof"; }
InToken         = "in"               !IdentifierPart { return "in"; }
NewToken        = "new"              !IdentifierPart
NullToken       = "null"             !IdentifierPart
ReturnToken     = "return"           !IdentifierPart
SetToken        = "set"              !IdentifierPart
SwitchToken     = "switch"           !IdentifierPart
ThisToken       = "this"             !IdentifierPart
ThrowToken      = "throw"            !IdentifierPart
TrueToken       = "true"             !IdentifierPart
TryToken        = "try"              !IdentifierPart
TypeofToken     = "typeof"           !IdentifierPart { return "typeof"; }
VarToken        = "var"              !IdentifierPart
VoidToken       = "void"             !IdentifierPart { return "void"; }
WhileToken      = "while"            !IdentifierPart
WithToken       = "with"             !IdentifierPart

/*
 * Unicode Character Categories
 *
 * Source: http://www.fileformat.info/info/unicode/category/index.htm
 */

/*
 * Non-BMP characters are completely ignored to avoid surrogate pair handling
 * (JavaScript strings in most implementations are encoded in UTF-16, though
 * this is not required by the specification -- see ECMA-262, 5th ed., 4.3.16).
 *
 * If you ever need to correctly recognize all the characters, please feel free
 * to implement that and send a patch.
 */

// Letter, Lowercase
Ll = [a-z]

// Letter, Modifier
Lm = [\u02B0\u02B1\u02B2\u02B3\u02B4\u02B5\u02B6\u02B7\u02B8\u02B9\u02BA\u02BB\u02BC\u02BD\u02BE\u02BF\u02C0\u02C1\u02C6\u02C7\u02C8\u02C9\u02CA\u02CB\u02CC\u02CD\u02CE\u02CF\u02D0\u02D1\u02E0\u02E1\u02E2\u02E3\u02E4\u02EC\u02EE\u0374\u037A\u0559\u0640\u06E5\u06E6\u07F4\u07F5\u07FA\u0971\u0E46\u0EC6\u10FC\u17D7\u1843\u1C78\u1C79\u1C7A\u1C7B\u1C7C\u1C7D\u1D2C\u1D2D\u1D2E\u1D2F\u1D30\u1D31\u1D32\u1D33\u1D34\u1D35\u1D36\u1D37\u1D38\u1D39\u1D3A\u1D3B\u1D3C\u1D3D\u1D3E\u1D3F\u1D40\u1D41\u1D42\u1D43\u1D44\u1D45\u1D46\u1D47\u1D48\u1D49\u1D4A\u1D4B\u1D4C\u1D4D\u1D4E\u1D4F\u1D50\u1D51\u1D52\u1D53\u1D54\u1D55\u1D56\u1D57\u1D58\u1D59\u1D5A\u1D5B\u1D5C\u1D5D\u1D5E\u1D5F\u1D60\u1D61\u1D78\u1D9B\u1D9C\u1D9D\u1D9E\u1D9F\u1DA0\u1DA1\u1DA2\u1DA3\u1DA4\u1DA5\u1DA6\u1DA7\u1DA8\u1DA9\u1DAA\u1DAB\u1DAC\u1DAD\u1DAE\u1DAF\u1DB0\u1DB1\u1DB2\u1DB3\u1DB4\u1DB5\u1DB6\u1DB7\u1DB8\u1DB9\u1DBA\u1DBB\u1DBC\u1DBD\u1DBE\u1DBF\u2090\u2091\u2092\u2093\u2094\u2C7D\u2D6F\u2E2F\u3005\u3031\u3032\u3033\u3034\u3035\u303B\u309D\u309E\u30FC\u30FD\u30FE\uA015\uA60C\uA67F\uA717\uA718\uA719\uA71A\uA71B\uA71C\uA71D\uA71E\uA71F\uA770\uA788\uFF70\uFF9E\uFF9F]

// Letter, Titlecase
Lt = [\u01C5\u01C8\u01CB\u01F2\u1F88\u1F89\u1F8A\u1F8B\u1F8C\u1F8D\u1F8E\u1F8F\u1F98\u1F99\u1F9A\u1F9B\u1F9C\u1F9D\u1F9E\u1F9F\u1FA8\u1FA9\u1FAA\u1FAB\u1FAC\u1FAD\u1FAE\u1FAF\u1FBC\u1FCC\u1FFC]

// Letter, Uppercase
Lu = [A-Z]

// Mark, Spacing Combining
Mc = [\u0903\u093E\u093F\u0940\u0949\u094A\u094B\u094C\u0982\u0983\u09BE\u09BF\u09C0\u09C7\u09C8\u09CB\u09CC\u09D7\u0A03\u0A3E\u0A3F\u0A40\u0A83\u0ABE\u0ABF\u0AC0\u0AC9\u0ACB\u0ACC\u0B02\u0B03\u0B3E\u0B40\u0B47\u0B48\u0B4B\u0B4C\u0B57\u0BBE\u0BBF\u0BC1\u0BC2\u0BC6\u0BC7\u0BC8\u0BCA\u0BCB\u0BCC\u0BD7\u0C01\u0C02\u0C03\u0C41\u0C42\u0C43\u0C44\u0C82\u0C83\u0CBE\u0CC0\u0CC1\u0CC2\u0CC3\u0CC4\u0CC7\u0CC8\u0CCA\u0CCB\u0CD5\u0CD6\u0D02\u0D03\u0D3E\u0D3F\u0D40\u0D46\u0D47\u0D48\u0D4A\u0D4B\u0D4C\u0D57\u0D82\u0D83\u0DCF\u0DD0\u0DD1\u0DD8\u0DD9\u0DDA\u0DDB\u0DDC\u0DDD\u0DDE\u0DDF\u0DF2\u0DF3\u0F3E\u0F3F\u0F7F\u102B\u102C\u1031\u1038\u103B\u103C\u1056\u1057\u1062\u1063\u1064\u1067\u1068\u1069\u106A\u106B\u106C\u106D\u1083\u1084\u1087\u1088\u1089\u108A\u108B\u108C\u108F\u17B6\u17BE\u17BF\u17C0\u17C1\u17C2\u17C3\u17C4\u17C5\u17C7\u17C8\u1923\u1924\u1925\u1926\u1929\u192A\u192B\u1930\u1931\u1933\u1934\u1935\u1936\u1937\u1938\u19B0\u19B1\u19B2\u19B3\u19B4\u19B5\u19B6\u19B7\u19B8\u19B9\u19BA\u19BB\u19BC\u19BD\u19BE\u19BF\u19C0\u19C8\u19C9\u1A19\u1A1A\u1A1B\u1B04\u1B35\u1B3B\u1B3D\u1B3E\u1B3F\u1B40\u1B41\u1B43\u1B44\u1B82\u1BA1\u1BA6\u1BA7\u1BAA\u1C24\u1C25\u1C26\u1C27\u1C28\u1C29\u1C2A\u1C2B\u1C34\u1C35\uA823\uA824\uA827\uA880\uA881\uA8B4\uA8B5\uA8B6\uA8B7\uA8B8\uA8B9\uA8BA\uA8BB\uA8BC\uA8BD\uA8BE\uA8BF\uA8C0\uA8C1\uA8C2\uA8C3\uA952\uA953\uAA2F\uAA30\uAA33\uAA34\uAA4D]

// Mark, Nonspacing
Mn = [\u0300\u0301\u0302\u0303\u0304\u0305\u0306\u0307\u0308\u0309\u030A\u030B\u030C\u030D\u030E\u030F\u0310\u0311\u0312\u0313\u0314\u0315\u0316\u0317\u0318\u0319\u031A\u031B\u031C\u031D\u031E\u031F\u0320\u0321\u0322\u0323\u0324\u0325\u0326\u0327\u0328\u0329\u032A\u032B\u032C\u032D\u032E\u032F\u0330\u0331\u0332\u0333\u0334\u0335\u0336\u0337\u0338\u0339\u033A\u033B\u033C\u033D\u033E\u033F\u0340\u0341\u0342\u0343\u0344\u0345\u0346\u0347\u0348\u0349\u034A\u034B\u034C\u034D\u034E\u034F\u0350\u0351\u0352\u0353\u0354\u0355\u0356\u0357\u0358\u0359\u035A\u035B\u035C\u035D\u035E\u035F\u0360\u0361\u0362\u0363\u0364\u0365\u0366\u0367\u0368\u0369\u036A\u036B\u036C\u036D\u036E\u036F\u0483\u0484\u0485\u0486\u0487\u0591\u0592\u0593\u0594\u0595\u0596\u0597\u0598\u0599\u059A\u059B\u059C\u059D\u059E\u059F\u05A0\u05A1\u05A2\u05A3\u05A4\u05A5\u05A6\u05A7\u05A8\u05A9\u05AA\u05AB\u05AC\u05AD\u05AE\u05AF\u05B0\u05B1\u05B2\u05B3\u05B4\u05B5\u05B6\u05B7\u05B8\u05B9\u05BA\u05BB\u05BC\u05BD\u05BF\u05C1\u05C2\u05C4\u05C5\u05C7\u0610\u0611\u0612\u0613\u0614\u0615\u0616\u0617\u0618\u0619\u061A\u064B\u064C\u064D\u064E\u064F\u0650\u0651\u0652\u0653\u0654\u0655\u0656\u0657\u0658\u0659\u065A\u065B\u065C\u065D\u065E\u0670\u06D6\u06D7\u06D8\u06D9\u06DA\u06DB\u06DC\u06DF\u06E0\u06E1\u06E2\u06E3\u06E4\u06E7\u06E8\u06EA\u06EB\u06EC\u06ED\u0711\u0730\u0731\u0732\u0733\u0734\u0735\u0736\u0737\u0738\u0739\u073A\u073B\u073C\u073D\u073E\u073F\u0740\u0741\u0742\u0743\u0744\u0745\u0746\u0747\u0748\u0749\u074A\u07A6\u07A7\u07A8\u07A9\u07AA\u07AB\u07AC\u07AD\u07AE\u07AF\u07B0\u07EB\u07EC\u07ED\u07EE\u07EF\u07F0\u07F1\u07F2\u07F3\u0901\u0902\u093C\u0941\u0942\u0943\u0944\u0945\u0946\u0947\u0948\u094D\u0951\u0952\u0953\u0954\u0962\u0963\u0981\u09BC\u09C1\u09C2\u09C3\u09C4\u09CD\u09E2\u09E3\u0A01\u0A02\u0A3C\u0A41\u0A42\u0A47\u0A48\u0A4B\u0A4C\u0A4D\u0A51\u0A70\u0A71\u0A75\u0A81\u0A82\u0ABC\u0AC1\u0AC2\u0AC3\u0AC4\u0AC5\u0AC7\u0AC8\u0ACD\u0AE2\u0AE3\u0B01\u0B3C\u0B3F\u0B41\u0B42\u0B43\u0B44\u0B4D\u0B56\u0B62\u0B63\u0B82\u0BC0\u0BCD\u0C3E\u0C3F\u0C40\u0C46\u0C47\u0C48\u0C4A\u0C4B\u0C4C\u0C4D\u0C55\u0C56\u0C62\u0C63\u0CBC\u0CBF\u0CC6\u0CCC\u0CCD\u0CE2\u0CE3\u0D41\u0D42\u0D43\u0D44\u0D4D\u0D62\u0D63\u0DCA\u0DD2\u0DD3\u0DD4\u0DD6\u0E31\u0E34\u0E35\u0E36\u0E37\u0E38\u0E39\u0E3A\u0E47\u0E48\u0E49\u0E4A\u0E4B\u0E4C\u0E4D\u0E4E\u0EB1\u0EB4\u0EB5\u0EB6\u0EB7\u0EB8\u0EB9\u0EBB\u0EBC\u0EC8\u0EC9\u0ECA\u0ECB\u0ECC\u0ECD\u0F18\u0F19\u0F35\u0F37\u0F39\u0F71\u0F72\u0F73\u0F74\u0F75\u0F76\u0F77\u0F78\u0F79\u0F7A\u0F7B\u0F7C\u0F7D\u0F7E\u0F80\u0F81\u0F82\u0F83\u0F84\u0F86\u0F87\u0F90\u0F91\u0F92\u0F93\u0F94\u0F95\u0F96\u0F97\u0F99\u0F9A\u0F9B\u0F9C\u0F9D\u0F9E\u0F9F\u0FA0\u0FA1\u0FA2\u0FA3\u0FA4\u0FA5\u0FA6\u0FA7\u0FA8\u0FA9\u0FAA\u0FAB\u0FAC\u0FAD\u0FAE\u0FAF\u0FB0\u0FB1\u0FB2\u0FB3\u0FB4\u0FB5\u0FB6\u0FB7\u0FB8\u0FB9\u0FBA\u0FBB\u0FBC\u0FC6\u102D\u102E\u102F\u1030\u1032\u1033\u1034\u1035\u1036\u1037\u1039\u103A\u103D\u103E\u1058\u1059\u105E\u105F\u1060\u1071\u1072\u1073\u1074\u1082\u1085\u1086\u108D\u135F\u1712\u1713\u1714\u1732\u1733\u1734\u1752\u1753\u1772\u1773\u17B7\u17B8\u17B9\u17BA\u17BB\u17BC\u17BD\u17C6\u17C9\u17CA\u17CB\u17CC\u17CD\u17CE\u17CF\u17D0\u17D1\u17D2\u17D3\u17DD\u180B\u180C\u180D\u18A9\u1920\u1921\u1922\u1927\u1928\u1932\u1939\u193A\u193B\u1A17\u1A18\u1B00\u1B01\u1B02\u1B03\u1B34\u1B36\u1B37\u1B38\u1B39\u1B3A\u1B3C\u1B42\u1B6B\u1B6C\u1B6D\u1B6E\u1B6F\u1B70\u1B71\u1B72\u1B73\u1B80\u1B81\u1BA2\u1BA3\u1BA4\u1BA5\u1BA8\u1BA9\u1C2C\u1C2D\u1C2E\u1C2F\u1C30\u1C31\u1C32\u1C33\u1C36\u1C37\u1DC0\u1DC1\u1DC2\u1DC3\u1DC4\u1DC5\u1DC6\u1DC7\u1DC8\u1DC9\u1DCA\u1DCB\u1DCC\u1DCD\u1DCE\u1DCF\u1DD0\u1DD1\u1DD2\u1DD3\u1DD4\u1DD5\u1DD6\u1DD7\u1DD8\u1DD9\u1DDA\u1DDB\u1DDC\u1DDD\u1DDE\u1DDF\u1DE0\u1DE1\u1DE2\u1DE3\u1DE4\u1DE5\u1DE6\u1DFE\u1DFF\u20D0\u20D1\u20D2\u20D3\u20D4\u20D5\u20D6\u20D7\u20D8\u20D9\u20DA\u20DB\u20DC\u20E1\u20E5\u20E6\u20E7\u20E8\u20E9\u20EA\u20EB\u20EC\u20ED\u20EE\u20EF\u20F0\u2DE0\u2DE1\u2DE2\u2DE3\u2DE4\u2DE5\u2DE6\u2DE7\u2DE8\u2DE9\u2DEA\u2DEB\u2DEC\u2DED\u2DEE\u2DEF\u2DF0\u2DF1\u2DF2\u2DF3\u2DF4\u2DF5\u2DF6\u2DF7\u2DF8\u2DF9\u2DFA\u2DFB\u2DFC\u2DFD\u2DFE\u2DFF\u302A\u302B\u302C\u302D\u302E\u302F\u3099\u309A\uA66F\uA67C\uA67D\uA802\uA806\uA80B\uA825\uA826\uA8C4\uA926\uA927\uA928\uA929\uA92A\uA92B\uA92C\uA92D\uA947\uA948\uA949\uA94A\uA94B\uA94C\uA94D\uA94E\uA94F\uA950\uA951\uAA29\uAA2A\uAA2B\uAA2C\uAA2D\uAA2E\uAA31\uAA32\uAA35\uAA36\uAA43\uAA4C\uFB1E\uFE00\uFE01\uFE02\uFE03\uFE04\uFE05\uFE06\uFE07\uFE08\uFE09\uFE0A\uFE0B\uFE0C\uFE0D\uFE0E\uFE0F\uFE20\uFE21\uFE22\uFE23\uFE24\uFE25\uFE26]

// Number, Decimal Digit
Nd = [\0-9]

// Number, Letter
Nl = [0-9]

// Punctuation, Connector
Pc = [\u005F\u203F\u2040\u2054\uFE33\uFE34\uFE4D\uFE4E\uFE4F\uFF3F]

// Separator, Space
Zs = [\u0020\u00A0\u1680\u180E\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000]

/* Automatic Semicolon Insertion */

EOS
  = __ ";"
  / _ LineTerminatorSequence
  / _ &"}"
  / __ EOF

EOSNoLineTerminator
  = _ ";"
  / _ LineTerminatorSequence
  / _ &"}"
  / _ EOF

EOF
  = !.

/* Whitespace */

_
  = (WhiteSpace / SingleLineComment)*

__
  = (WhiteSpace / LineTerminatorSequence / Comment)*

___ 
  = (LineTerminatorSequence / Comment)*

/* ===== A.3 Expressions ===== */

PrimaryExpression
  = ThisToken       { return "This"; }
  / name:Identifier { return ""+name; }
  / Literal
  / ArrayLiteral

ArrayLiteral
  = "[" __ "]" {
      return "";
    }
  / "[" __ elements:ElementList __ "]" {
      return "["+elements+"]";
    }

ElementList
  = head:(
      element:SecondStatement {
        return element;
      }
    )
    tail:(
      __ ___ __ element:AssignmentExpression {
        return element;
      }
    )* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = result.concat(", "+tail[i]);
      }
      return result;
    }


ObjectLiteral
  = "{" __ properties:(PropertyNameAndValueList __ ("," __)?)? "}" {
      return {
        type:       "ObjectLiteral",
        properties: properties !== "" ? properties[0] : []
      };
    }

PropertyNameAndValueList
  = head:PropertyAssignment tail:(__ "," __ PropertyAssignment)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][3]);
      }
      return result;
    }

PropertyAssignment
  = name:PropertyName __ ":" __ value:AssignmentExpression {
      return {
        type:  "PropertyAssignment",
        name:  name,
        value: value
      };
    }
  / GetToken __ name:PropertyName __
    "(" __ ")" __
    "{" __ body:FunctionBody __ "}" {
      return {
        type: "GetterDefinition",
        name: name,
        body: body
      };
    }
  / SetToken __ name:PropertyName __
    "(" __ param:PropertySetParameterList __ ")" __
    "{" __ body:FunctionBody __ "}" {
      return {
        type:  "SetterDefinition",
        name:  name,
        param: param,
        body:  body
      };
    }

PropertyName
  = IdentifierName
  / StringLiteral

PropertySetParameterList
  = Identifier

MemberExpression
  = PrimaryExpression


CallExpression
  =   Variable
    / NumericLiteral
    /name:Identifier _ args:Arguments {
        return name!==""?(""+name+"("+args+")"):"";
      } 
    / MemberExpression   



Arguments
  = args:ArgumentList?  {
    return args !== "" ? args.join(", ") : "";
  }


ArgumentList
  = head:AssignmentExpression tail:(_ AssignmentExpression)* {
    var result = [head];
    for (var i = 0; i < tail.length; i++) {
      result.push(tail[i][1]);
    }
    return result;
  }


LeftHandSideExpression
  = CallExpression


UnaryExpression
  = LeftHandSideExpression
  / operator:UnaryOperator __ expression:UnaryExpression {
      return {
        type:       "UnaryExpression",
        operator:   operator,
        expression: expression
      };
    }

UnaryOperator
  = DeleteToken
  / VoidToken
  / TypeofToken
  / "++"
  / "--"
  / "+"
  / "-"
  / "~"
  /  "!"

MultiplicativeExpression
  = head:UnaryExpression
    tail:(__ MultiplicativeOperator __ UnaryExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

MultiplicativeOperator
  = operator:("*" / "/" / "%") !"=" { return operator; }

AdditiveExpression
  = head:MultiplicativeExpression
    tail:(__ AdditiveOperator __ MultiplicativeExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

AdditiveOperator
  = "+" !("+" / "=") { return "+"; }
  / "-" !("-" / "=") { return "-"; }

ShiftExpression
  = head:AdditiveExpression
    tail:(__ ShiftOperator __ AdditiveExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

ShiftOperator
  = "<<"
  / ">>>"
  / ">>"

RelationalExpression
  = head:ShiftExpression
    tail:(__ RelationalOperator __ ShiftExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

RelationalOperator
  = "<="
  / ">="
  / "<"
  / ">"
  / InstanceofToken
  / InToken

RelationalExpressionNoIn
  = head:ShiftExpression
    tail:(__ RelationalOperatorNoIn __ ShiftExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

RelationalOperatorNoIn
  = "<="
  / ">="
  / "<"
  / ">"
  / InstanceofToken

EqualityExpression
  = head:RelationalExpression
    tail:(__ EqualityOperator __ RelationalExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

EqualityExpressionNoIn
  = head:RelationalExpressionNoIn
    tail:(__ EqualityOperator __ RelationalExpressionNoIn)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

EqualityOperator
  = "==="
  / "!=="
  / "=="
  / "!="

BitwiseANDExpression
  = head:EqualityExpression
    tail:(__ BitwiseANDOperator __ EqualityExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

BitwiseANDExpressionNoIn
  = head:EqualityExpressionNoIn
    tail:(__ BitwiseANDOperator __ EqualityExpressionNoIn)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

BitwiseANDOperator
  = "&" !("&" / "=") { return "&"; }

BitwiseXORExpression
  = head:BitwiseANDExpression
    tail:(__ BitwiseXOROperator __ BitwiseANDExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

BitwiseXORExpressionNoIn
  = head:BitwiseANDExpressionNoIn
    tail:(__ BitwiseXOROperator __ BitwiseANDExpressionNoIn)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

BitwiseXOROperator
  = "^" !("^" / "=") { return "^"; }

BitwiseORExpression
  = head:BitwiseXORExpression
    tail:(__ BitwiseOROperator __ BitwiseXORExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

BitwiseORExpressionNoIn
  = head:BitwiseXORExpressionNoIn
    tail:(__ BitwiseOROperator __ BitwiseXORExpressionNoIn)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

BitwiseOROperator
  = "|" !("|" / "=") { return "|"; }

LogicalANDExpression
  = head:BitwiseORExpression
    tail:(__ LogicalANDOperator __ BitwiseORExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

LogicalANDExpressionNoIn
  = head:BitwiseORExpressionNoIn
    tail:(__ LogicalANDOperator __ BitwiseORExpressionNoIn)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

LogicalANDOperator
  = "&&" !"=" { return "&&"; }

LogicalORExpression
  = head:LogicalANDExpression
    tail:(__ LogicalOROperator __ LogicalANDExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

LogicalORExpressionNoIn
  = head:LogicalANDExpressionNoIn
    tail:(__ LogicalOROperator __ LogicalANDExpressionNoIn)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

LogicalOROperator
  = "||" !"=" { return "||"; }

ConditionalExpression
  = condition:LogicalORExpression __
    "?" __ trueExpression:AssignmentExpression __
    ":" __ falseExpression:AssignmentExpression {
      return {
        type:            "ConditionalExpression",
        condition:       condition,
        trueExpression:  trueExpression,
        falseExpression: falseExpression
      };
    }
  / LogicalORExpression

ConditionalExpressionNoIn
  = condition:LogicalORExpressionNoIn __
    "?" __ trueExpression:AssignmentExpressionNoIn __
    ":" __ falseExpression:AssignmentExpressionNoIn {
      return {
        type:            "ConditionalExpression",
        condition:       condition,
        trueExpression:  trueExpression,
        falseExpression: falseExpression
      };
    }
  / LogicalORExpressionNoIn

AssignmentExpression
  = left:LeftHandSideExpression __
    operator:AssignmentOperator __
    right:AssignmentExpression {
      return {
        type:     "AssignmentExpression",
        operator: operator,
        left:     left,
        right:    right
      };
    }
  / ConditionalExpression

AssignmentExpressionNoIn
  = left:LeftHandSideExpression __
    operator:AssignmentOperator __
    right:AssignmentExpressionNoIn {
      return {
        type:     "AssignmentExpression",
        operator: operator,
        left:     left,
        right:    right
      };
    }
  / ConditionalExpressionNoIn

AssignmentOperator
  = "=" (!"=") { return "="; }
  / "*="
  / "/="
  / "%="
  / "+="
  / "-="
  / "<<="
  / ">>="
  / ">>>="
  / "&="
  / "^="
  / "|="

Expression
  = head:AssignmentExpression
    tail:(__ "," __ AssignmentExpression)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

ExpressionNoIn
  = head:AssignmentExpressionNoIn
    tail:(__ "," __ AssignmentExpressionNoIn)* {
      var result = head;
      for (var i = 0; i < tail.length; i++) {
        result = {
          type:     "BinaryExpression",
          operator: tail[i][1],
          left:     result,
          right:    tail[i][3]
        };
      }
      return result;
    }

/* ===== A.4 Statements ===== */

/*
 * The specification does not consider |FunctionDeclaration| and
 * |FunctionExpression| as statements, but JavaScript implementations do and so
 * are we. This syntax is actually used in the wild (e.g. by jQuery).
 */
Statement
  = Block
  / VariableStatement
  / ExpressionStatement
  / IfStatement
  / IterationStatement
  / ContinueStatement
  / BreakStatement
  / ReturnStatement
  / WithStatement
  / LabelledStatement
  / SwitchStatement
  / ThrowStatement
  / TryStatement
  / DebuggerStatement
  / FunctionDeclaration
  
SecondStatement
  = Block
  / VariableStatement
  / ExpressionStatement
  / IfStatement
  / IterationStatement
  / ContinueStatement
  / BreakStatement
  / ReturnStatement
  / WithStatement
  / LabelledStatement
  / SwitchStatement
  / ThrowStatement
  / TryStatement
  / DebuggerStatement
  / CallExpression
  
FirstStatement
  = VariableStatement
  / FunctionDeclaration

Block
  = "{" __ statements:(StatementList __)? "}" {
      return {
        type:       "Block",
        statements: statements !== "" ? statements[0] : []
      };
    }

StatementList
  = head:Statement tail:(__ Statement)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result.join(" ");
    }

VariableStatement
  = VarToken __ declarations:VariableDeclarationList EOS {
      return {
        type:         "VariableStatement",
        declarations: declarations
      };
    }

VariableDeclarationList
  = head:VariableDeclaration tail:(__ "," __ VariableDeclaration)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][3]);
      }
      return result.join(", ");
    }

VariableDeclarationListNoIn
  = head:VariableDeclarationNoIn tail:(__ "," __ VariableDeclarationNoIn)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][3]);
      }
      return result;
    }

VariableDeclaration
  = name:Identifier value:(__ Initialiser)? {
      return {
        type:  "VariableDeclaration",
        name:  name,
        value: value !== "" ? value[1] : null
      };
    }

VariableDeclarationNoIn
  = name:Identifier value:(__ InitialiserNoIn)? {
      return {
        type:  "VariableDeclaration",
        name:  name,
        value: value !== "" ? value[1] : null
      };
    }

Initialiser
  = "=" (!"=") __ expression:AssignmentExpression { return expression; }

InitialiserNoIn
  = "=" (!"=") __ expression:AssignmentExpressionNoIn { return expression; }

ExpressionStatement
  = !("{" / ProcedureToken) expression:Expression EOS { return expression; }

IfStatement
  = IfToken __
    "(" __ condition:Expression __ ")" __
    ifStatement:Statement
    elseStatement:(__ ElseToken __ Statement)? {
      return {
        type:          "IfStatement",
        condition:     condition,
        ifStatement:   ifStatement,
        elseStatement: elseStatement !== "" ? elseStatement[3] : null
      };
    }

IterationStatement
  = DoWhileStatement
  / WhileStatement
  / ForStatement
  / ForInStatement

DoWhileStatement
  = DoToken __
    statement:Statement __
    WhileToken __ "(" __ condition:Expression __ ")" EOS {
      return {
        type: "DoWhileStatement",
        condition: condition,
        statement: statement
      };
    }

WhileStatement
  = WhileToken __ "(" __ condition:Expression __ ")" __ statement:Statement {
      return {
        type: "WhileStatement",
        condition: condition,
        statement: statement
      };
    }

ForStatement
  = ForToken __
    "(" __
    initializer:(
        VarToken __ declarations:VariableDeclarationListNoIn {
          return {
            type:         "VariableStatement",
            declarations: declarations
          };
        }
      / ExpressionNoIn?
    ) __
    ";" __
    test:Expression? __
    ";" __
    counter:Expression? __
    ")" __
    statement:Statement
    {
      return {
        type:        "ForStatement",
        initializer: initializer !== "" ? initializer : null,
        test:        test !== "" ? test : null,
        counter:     counter !== "" ? counter : null,
        statement:   statement
      };
    }

ForInStatement
  = ForToken __
    "(" __
    iterator:(
        VarToken __ declaration:VariableDeclarationNoIn { return declaration; }
      / LeftHandSideExpression
    ) __
    InToken __
    collection:Expression __
    ")" __
    statement:Statement
    {
      return {
        type:       "ForInStatement",
        iterator:   iterator,
        collection: collection,
        statement:  statement
      };
    }

ContinueStatement
  = ContinueToken _
    label:(
        identifier:Identifier EOS { return identifier; }
      / EOSNoLineTerminator       { return "";         }
    ) {
      return {
        type:  "ContinueStatement",
        label: label !== "" ? label : null
      };
    }

BreakStatement
  = BreakToken _
    label:(
        identifier:Identifier EOS { return identifier; }
      / EOSNoLineTerminator       { return ""; }
    ) {
      return {
        type:  "BreakStatement",
        label: label !== "" ? label : null
      };
    }

ReturnStatement
  = ReturnToken _
    value:(
        expression:Expression EOS { return expression; }
      / EOSNoLineTerminator       { return ""; }
    ) {
      return {
        type:  "ReturnStatement",
        value: value !== "" ? value : null
      };
    }

WithStatement
  = WithToken __ "(" __ environment:Expression __ ")" __ statement:Statement {
      return {
        type:        "WithStatement",
        environment: environment,
        statement:   statement
      };
    }

SwitchStatement
  = SwitchToken __ "(" __ expression:Expression __ ")" __ clauses:CaseBlock {
      return {
        type:       "SwitchStatement",
        expression: expression,
        clauses:    clauses
      };
    }

CaseBlock
  = "{" __
    before:CaseClauses?
    defaultAndAfter:(__ DefaultClause __ CaseClauses?)? __
    "}" {
      var before = before !== "" ? before : [];
      if (defaultAndAfter !== "") {
        var defaultClause = defaultAndAfter[1];
        var clausesAfter = defaultAndAfter[3] !== ""
          ? defaultAndAfter[3]
          : [];
      } else {
        var defaultClause = null;
        var clausesAfter = [];
      }

      return (defaultClause ? before.concat(defaultClause) : before).concat(clausesAfter);
    }

CaseClauses
  = head:CaseClause tail:(__ CaseClause)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result;
    }

CaseClause
  = CaseToken __ selector:Expression __ ":" statements:(__ StatementList)? {
      return {
        type:       "CaseClause",
        selector:   selector,
        statements: statements !== "" ? statements[1] : []
      };
    }

DefaultClause
  = DefaultToken __ ":" statements:(__ StatementList)? {
      return {
        type:       "DefaultClause",
        statements: statements !== "" ? statements[1] : []
      };
    }

LabelledStatement
  = label:Identifier __ ":" __ statement:Statement {
      return {
        type:      "LabelledStatement",
        label:     label,
        statement: statement
      };
    }

ThrowStatement
  = ThrowToken _ exception:Expression EOSNoLineTerminator {
      return {
        type:      "ThrowStatement",
        exception: exception
      };
    }

TryStatement
  = TryToken __ block:Block __ catch_:Catch __ finally_:Finally {
      return {
        type:      "TryStatement",
        block:     block,
        "catch":   catch_,
        "finally": finally_
      };
    }
  / TryToken __ block:Block __ catch_:Catch {
      return {
        type:      "TryStatement",
        block:     block,
        "catch":   catch_,
        "finally": null
      };
    }
  / TryToken __ block:Block __ finally_:Finally {
      return {
        type:      "TryStatement",
        block:     block,
        "catch":   null,
        "finally": finally_
      };
    }

Catch
  = CatchToken __ "(" __ identifier:Identifier __ ")" __ block:Block {
      return {
        type:       "Catch",
        identifier: identifier,
        block:      block
      };
    }

Finally
  = FinallyToken __ block:Block {
      return {
        type:  "Finally",
        block: block
      };
    }

DebuggerStatement
  = DebuggerToken EOS { return { type: "DebuggerStatement" }; }

/* ===== A.5 Functions and Programs ===== */

FunctionDeclaration
  = ProcedureToken __ name:Identifier ___
    ("[" _ params:FormalParameterList? _ "]")* ___
     __ elements:FunctionBody __ ProcedureEndToken {
      return "var " +name+ " = function(){\n"+elements+";\n};"
    }

FormalParameterList
  = head:Identifier tail:(_ Identifier)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][3]);
      }
      return result;
    }

FunctionBody
  = elements:SecondElements? { return elements !== "" ? "  "+elements.join(";\n  ") : ""; }

Program
  = elements:SourceElements? {
      return elements !== "" ? elements.join("\n\n") : "";
    }

SourceElements
  = head:SourceElement tail:(__ SourceElement)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result;
    }

SecondElements
  = head:SecondElement tail:(__ SecondElement)* {
      var result = [head];
      for (var i = 0; i < tail.length; i++) {
        result.push(tail[i][1]);
      }
      return result;
    }

/*
 * The specification also allows |FunctionDeclaration| here. We do it
 * implicitly, because we consider |FunctionDeclaration| and
 * |FunctionExpression| as statements. See the comment at the |Statement| rule.
 */
SourceElement
  = FirstStatement
  
SecondElement
  = SecondStatement
