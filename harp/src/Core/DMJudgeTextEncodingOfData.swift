//  Thanks to http://web.dormousesf.com/prog/TextEncoding/
//
//  DMJudgeTextEncoding.swift
//
//  Created by Takeshi Yamane on 2016/02/01.
//  DOBON!さん（http://dobon.net/index.html）がC#へ移植されたものをSwiftへ移植したものです。
//  Jcode.pmのgetcodeメソッドを移植したものです。
//  Jcode.pm(http://openlab.ring.gr.jp/Jcode/index-j.html)
//  Jcode.pmのCopyright: Copyright 1999-2005 Dan Kogai
//

import Foundation

// Constants
fileprivate let bEscape: UInt8 = 0x1B
fileprivate let bAt: UInt8 = 0x40
fileprivate let bDollar: UInt8 = 0x24
fileprivate let bAnd: UInt8 = 0x26
fileprivate let bOpen: UInt8 = 0x28 //'('
fileprivate let bB: UInt8 = 0x42
fileprivate let bD: UInt8 = 0x44
fileprivate let bJ: UInt8 = 0x4A
fileprivate let bI: UInt8 = 0x49
fileprivate let unknownEncoding = String.Encoding.utf8

//
// Judge text encoding
//
func DMJudgeTextEncodingOfData(rawData: NSData) -> String.Encoding {
  var b1: UInt8
  var b2: UInt8
  var b3: UInt8
  var b4: UInt8

  // NSDataからバイト配列へ
  var bytes = [UInt8](repeating: 0, count: rawData.length)
  rawData.getBytes(&bytes, length: rawData.length)

  let len: Int = rawData.length

  var isBinary: Bool = false
  for i in 0..<len {
    b1 = bytes[i]
    if b1 <= 0x06 || b1 == 0x7F || b1 == 0xFF {
      // 'binary'
      isBinary = true
      if b1 == 0x00 && i < len - 1 && bytes[i + 1] <= 0x7F {
        // smells like raw unicode
        return String.Encoding.unicode
      }
    }
  }
  if isBinary {
    return unknownEncoding
  }

  // not Japanese
  var notJapanese: Bool = true
  for i in 0..<len {
    b1 = bytes[i]
    if b1 == bEscape || 0x80 <= b1 {
      notJapanese = false
      break
    }
  }
  if notJapanese {
    return String.Encoding.ascii
  }

  for i in 0..<len - 2 {
    b1 = bytes[i]
    b2 = bytes[i + 1]
    b3 = bytes[i + 2]

    if b1 == bEscape {
      if b2 == bDollar && b3 == bAt {
        // JIS_0208 1978
        // JIS
        return String.Encoding.iso2022JP
      } else if b2 == bDollar && b3 == bB {
        // JIS_0208 1983
        // JIS
        return String.Encoding.iso2022JP

      } else if b2 == bOpen && (b3 == bB || b3 == bJ) {
        // JIS_ASC
        // JIS
        return String.Encoding.iso2022JP
      } else if b2 == bOpen && b3 == bI {
        // JIS_KANA
        // JIS
        return String.Encoding.iso2022JP
      }
      if i < len - 3 {
        b4 = bytes[i + 3]
        if b2 == bDollar && b3 == bOpen && b4 == bD {
          // JIS_0212
          // JIS
          return String.Encoding.iso2022JP
        }
        if i < len - 5 && b2 == bAnd && b3 == bAt && b4 == bEscape && bytes[i + 4] == bDollar && bytes[i + 5] == bB {
          // JIS_0208 1990
          // JIS
          return String.Encoding.iso2022JP
        }
      }
    }
  }

  // should be euc|sjis|utf8
  // use of (?:) by Hiroki Ohzaki <ohzaki@iod.ricoh.co.jp>
  var sjis: Int = 0
  var euc: Int = 0
  var utf8: Int = 0

  var i = 0
  while i < len - 1 {
    b1 = bytes[i]
    b2 = bytes[i + 1]
    if ((0x81 <= b1 && b1 <= 0x9F) || (0xE0 <= b1 && b1 <= 0xFC)) && ((0x40 <= b2 && b2 <= 0x7E) || (0x80 <= b2 && b2 <= 0xFC)) {
      // SJIS_C
      sjis += 2
      i += 1
    }

    i += 1
  }

  i = 0
  while i < len - 1 {
    b1 = bytes[i]
    b2 = bytes[i + 1]
    if ((0xA1 <= b1 && b1 <= 0xFE) && (0xA1 <= b2 && b2 <= 0xFE)) || (b1 == 0x8E && (0xA1 <= b2 && b2 <= 0xDF)) {
      // EUC_C
      // EUC_KANA
      euc += 2
      i += 1
    } else if i < len - 2 {
      b3 = bytes[i + 2]
      if b1 == 0x8F && (0xA1 <= b2 && b2 <= 0xFE) && (0xA1 <= b3 && b3 <= 0xFE) {
        // EUC_0212
        euc += 3
        i += 2
      }
    }

    i += 1
  }

  i = 0
  while i < len - 1 {
    b1 = bytes[i]
    b2 = bytes[i + 1]
    if (0xC0 <= b1 && b1 <= 0xDF) && (0x80 <= b2 && b2 <= 0xBF) {
      // UTF8
      utf8 += 2
      i += 1
    } else if i < len - 2 {
      b3 = bytes[i + 2]
      if (0xE0 <= b1 && b1 <= 0xEF) && (0x80 <= b2 && b2 <= 0xBF) && (0x80 <= b3 && b3 <= 0xBF) {
        // UTF8
        utf8 += 3
        i += 2
      }
    }

    i += 1
  }

  // M. Takahashi's suggestion
  // utf8 += utf8 / 2

  Logger.info ("sjis = \(sjis), euc = \(euc), utf8 = \(utf8)")

  if euc > sjis && euc > utf8 {
    // EUC
    return String.Encoding.japaneseEUC
  } else if sjis > euc && sjis > utf8 {
    // SJIS
    return String.Encoding.shiftJIS
  } else if utf8 > euc && utf8 > sjis {
    // UTF-8
    return String.Encoding.utf8
  }

  return unknownEncoding
}
