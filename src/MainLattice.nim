include MainMerit

proc verify(entry: Entry) {.raises: [KeyError, ValueError, FinalAttributeError].} =
    if miner:
        #Verify the Entry.
        var verif: MemoryVerification = merit.verify(entry.hash)
        discard lattice.verify(merit, verif)

        discard """
        #Broadcast the Verification.
        events.get(
            proc (msgType: MessageType, msg: string),
            "network.broadcast"
        )(
            MessageType.Verification,
            verif.serialize()
        )
        """

proc mainLattice*() {.raises: [
    ValueError,
    ArgonError,
    SodiumError,
    MintError,
    FinalAttributeError
].} =
    {.gcsafe.}:
        #Create the Lattice.
        lattice = newLattice(
            TRANSACTION_DIFFICULTY,
            DATA_DIFFICULTY
        )

        #Create the Genesis Send.
        genesisSend = lattice.mint(
            MINT_ADDRESS,
            newBN(MINT_AMOUNT)
        )

        #Handle Sends.
        events.on(
            "lattice.send",
            proc (send: Send): bool {.raises: [
                ValueError,
                SodiumError,
                FinalAttributeError
            ].} =
                #Print that we're adding the Entry.
                echo "Adding a new Send."

                #Add the Send.
                if lattice.add(
                    merit,
                    send
                ):
                    result = true
                    echo "Successfully added the Send."

                    verify(send)

                else:
                    result = false
                    echo "Failed to add the Send."
                echo ""
        )

        #Handle Receives.
        events.on(
            "lattice.receive",
            proc (recv: Receive): bool {.raises: [
                ValueError,
                SodiumError,
                FinalAttributeError
            ].} =
                #Print that we're adding the Entry.
                echo "Adding a new Receive."

                #Add the Receive.
                if lattice.add(
                    merit,
                    recv
                ):
                    result = true
                    echo "Successfully added the Receive."

                    verify(recv)
                else:
                    result = false
                    echo "Failed to add the Receive."
                echo ""
        )

        #Handle Data.
        events.on(
            "lattice.data",
            proc (
                msg: Message,
                data: Data
            ): bool {.raises: [
                ValueError,
                SodiumError,
                FinalAttributeError
            ].} =
                #Print that we're adding the Entry.
                echo "Adding a new Data."

                #Add the Data.
                if lattice.add(
                    merit,
                    data
                ):
                    result = true
                    echo "Successfully added the Data."

                    verify(data)
                else:
                    result = false
                    echo "Failed to add the Data."
                echo ""
        )

        #Handle requests for an account's height.
        events.on(
            "lattice.getHeight",
            proc (account: string): uint {.raises: [ValueError].} =
                lattice.getAccount(account).height
        )

        #Handle requests for an account's balance.
        events.on(
            "lattice.getBalance",
            proc (account: string): BN {.raises: [ValueError].} =
                lattice.getAccount(account).balance
        )

        #Print the Seed and address of the address holding the coins.
        echo MINT_ADDRESS & " was sent " & MINT_AMOUNT & " EMB from \"minter\".\r\n" &
            "Its Seed is " & MINT_SEED & ".\r\n"
