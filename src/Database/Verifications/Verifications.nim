#Errors.
import ../../lib/Errors

#BN lib.
import BN

#Hash lib.
import ../../lib/Hash

#BLS lib.
import ../../lib/BLS

#Index object.
import ../common/objects/IndexObj

#Verification and Verifier lib.
import Verification
import Verifier

#Verifications object.
import objects/Verifications

#Tables standard lib.
import tables

#Finals lib.
import finals

#Add a Verification.
proc add*(
    verifs: Verifications,
    verif: Verification
) {.raises: [IndexError].} =
    verifs[verif.verifier].add(verif)

#For each provided Index, archive all Verifications from the account's last archived to the provided nonce.
proc archive*(verifs: Verifications, indexes: seq[Index], archived: uint) {.raises: [].} =
    #Declare the start variable outside of the loop.
    var start: uint

    #Iterate over every Index.
    for index in indexes:
        #Calculate the start.
        start = verifs[index.key].archived + 1
        #Iterate over every Verification.
        for i in start .. index.nonce:
            #Archive the Verification.
            verifs[index].archive(archived)