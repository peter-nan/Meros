#Hash master type.
import HashCommon

#nimcrypto lib.
import nimcrypto

#String utils standard lib.
import strutils

#Define the Hash Types.
type
    SHA2_256Hash* = Hash[256]
    SHA2_512Hash* = Hash[512]

#SHA2 256 hash function.
proc SHA2_256*(bytesArg: string): SHA2_256Hash {.raises: [].} =
    #Copy the bytes argument.
    var bytes: string = bytesArg

    #If it's an empty string...
    if bytes.len == 0:
        return SHA2_256Hash(
            data: sha256.digest(empty, uint(bytes.len)).data
        )

    #Digest the byte array.
    result = SHA2_256Hash(
        data: sha256.digest(cast[ptr uint8](addr bytes[0]), uint(bytes.len)).data
    )

#SHA2 512 hash function.
proc SHA2_512*(bytesArg: string): SHA2_512Hash {.raises: [].} =
    #Copy the bytes argument.
    var bytes: string = bytesArg

    #If it's an empty string...
    if bytes.len == 0:
        return SHA2_512Hash(
            data: sha512.digest(empty, uint(bytes.len)).data
        )

    #Digest the byte array.
    result = SHA2_512Hash(
        data: sha512.digest(cast[ptr uint8](addr bytes[0]), uint(bytes.len)).data
    )

#String to SHA2_256Hash.
proc toSHA2_256Hash*(hex: string): SHA2_256Hash =
    for i in countup(0, hex.len - 1, 2):
        result.data[int(i / 2)] = uint8(parseHexInt(hex[i .. i + 1]))

#String to SHA2_512Hash.
proc toSHA2_512Hash*(hex: string): SHA2_512Hash =
    for i in countup(0, hex.len - 1, 2):
        result.data[int(i / 2)] = uint8(parseHexInt(hex[i .. i + 1]))
