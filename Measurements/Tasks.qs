// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.Measurements {
    
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Diagnostics; 
    
    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////
    
    // "Measurements" quantum kata is a series of exercises designed
    // to get you familiar with programming in Q#.
    // It covers the following topics:
    //  - single-qubit measurements,
    //  - discriminating orthogonal and nonorthogonal states.
    
    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.
    
    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks.
    
    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Measurements
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. |0⟩ or |1⟩ ?
    // Input: a qubit which is guaranteed to be in |0⟩ or |1⟩ state.
    // Output: true if qubit was in |1⟩ state, or false if it was in |0⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitOne (q : Qubit) : Bool {
        // The operation M will measure a qubit in the Z basis (|0⟩ and |1⟩ basis)
        // and return Zero if the observed state was |0⟩ or One if the state was |1⟩.
        // To answer the question, you need to perform the measurement and check whether the result
        // equals One - either directly or using library function IsResultOne.
        //
        // Replace the returned expression with (M(q) == One)
        // Then rebuild the project and rerun the tests - T101_IsQubitOne_Test should now pass!

        return (M(q) == One);
    }
    
    
    // Task 1.2. Set qubit to |0⟩ state
    // Input: a qubit in an arbitrary state.
    // Goal:  change the state of the qubit to |0⟩.
    operation InitializeQubit (q : Qubit) : Unit {
        
        if (M(q) == One)
        {
            X(q); 
        }

    }
    
    
    // Task 1.3. |+⟩ or |-⟩ ?
    // Input: a qubit which is guaranteed to be in |+⟩ or |-⟩ state
    //        (|+⟩ = (|0⟩ + |1⟩) / sqrt(2), |-⟩ = (|0⟩ - |1⟩) / sqrt(2)).
    // Output: true if qubit was in |+⟩ state, or false if it was in |-⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitPlus (q : Qubit) : Bool {
        // ...
        H(q); 

        return M(q) == Zero;
    }
    
    
    // Task 1.4. |A⟩ or |B⟩ ?
    // Inputs:
    //      1) angle alpha, in radians, represented as Double
    //      2) a qubit which is guaranteed to be in |A⟩ or |B⟩ state
    //         |A⟩ =   cos(alpha) * |0⟩ + sin(alpha) * |1⟩,
    //         |B⟩ = - sin(alpha) * |0⟩ + cos(alpha) * |1⟩.
    // Output: true if qubit was in |A⟩ state, or false if it was in |B⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation IsQubitA (alpha : Double, q : Qubit) : Bool {

 
        // Since you don't know the axis, you can't assume which rotation basis is needed...
        // https://algassert.com/quirk#circuit={%22cols%22:[[%22H%22,%22Y^%C2%BD%22,%22X^%C2%BD%22],[%22Z^t%22]]}
        //Rx(-2.0 * Sin(alpha/2.0), q); 

        // The fact that they are orthogonal means...
        // that you can measure one and only destroy half of the information. 

        // Now, what happens if you take the states |𝜓0⟩ and |𝜓1⟩ and apply the adjoint 
        // of the transformation 𝑈 to them? You know that the state |𝜓0⟩ will be 
        // transformed to |000⟩, and the state |𝜓1⟩ will be transformed to some other state. 
        // It doesn't really matter what state it is, it's enough to know that it is orthogonal 
        // to |000⟩. So to distinguish these states you can measure all qubits after applying 
        // 𝑈† - if you get all zeroes, you know it was |𝜓0⟩, otherwise it was |𝜓1⟩.

        // Reference: 
        //#float(sin(1.5707963267949)) # sin(pi/2) = 1.0
        //# float(cos(1.5707963267949)) # cos(pi/2) = 0

        // e.g. Alpha: 1.5707963267949
        // |A⟩ =   cos(alpha) * |0⟩ + sin(alpha) * |1⟩
        // 0:      0       0
        // 1:      1       0
        //   OR 
        // |B⟩ = - sin(alpha) * |0⟩ + cos(alpha) * |1⟩.
        // 0:      1       0
        // 1:      0       0

        // let theta = (PI()/2.0)-alpha; 
        // if (theta > 0.0)
        // {
        //     Message($"R by {theta}"); 
        //     R1(-2.0 * theta, q); 

        //     DumpMachine(); 
        // }

        // Why Ry? You had to recognize this guy: 
        //         |A⟩ =   cos(alpha) * |0⟩ + sin(alpha) * |1⟩,
        //         |B⟩ = - sin(alpha) * |0⟩ + cos(alpha) * |1⟩.
        // Is the same as the definition of Ry: 
        // Further, if you intuition is based on the Bloch sphere, you may be confused why 
        // these are orthogonial therefore if one is 0, the other must be 1 (in the bloch sphere, orthognal means H, not X)

        Ry(-2.0 * alpha, q); 
        // Aka Adjoint Ry(2.0 * alpha, q); 

        if (M(q) == Zero) 
        {
            return true; 
        }
        else 
        {
            return false; 
        }      
    }

    // Other ideas? 

        
        // Use a cnot to copy the value to other qubits you can test. 

        // Joint measurement? 

        // To have two different measurement bases that you pick between. 
        // The first is as you specified. 
        // The second is the complementary view where you use (|𝜙⟩,|𝜙′⟩

        // Introduce a POVM. POVMs can have more than 2 measurement operators, 
        // and are often quite good at saying "the state was definitely not |𝑥⟩", 
        // so you could make one operator that says "the state definitely was not |𝜓⟩", 
        // another that says "definitely not |𝜙⟩" and a third just for the sake of completeness.


   

    
    
    // Task 1.5. |00⟩ or |11⟩ ?
    // Input: two qubits (stored in an array) which are guaranteed to be in |00⟩ or |11⟩ state.
    // Output: 0 if qubits were in |00⟩ state,
    //         1 if they were in |11⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation ZeroZeroOrOneOne (qs : Qubit[]) : Int {
        
        if (M(qs[0]) == Zero)
        {
            return 0; 
        }

        return 1; 
    }
    
    
    // Task 1.6. Distinguish four basis states
    // Input: two qubits (stored in an array) which are guaranteed to be
    //        in one of the four basis states (|00⟩, |01⟩, |10⟩ or |11⟩).
    // Output: 0 if qubits were in |00⟩ state,
    //         1 if they were in |01⟩ state,
    //         2 if they were in |10⟩ state,
    //         3 if they were in |11⟩ state.
    // In this task and the subsequent ones the order of qubit states
    // in task description matches the order of qubits in the array
    // (i.e., |10⟩ state corresponds to qs[0] in state |1⟩ and qs[1] in state |0⟩).
    // The state of the qubits at the end of the operation does not matter.
    operation BasisStateMeasurement (qs : Qubit[]) : Int {
        
        // Joint measurement would be over two axis?

        // You probably just want to measure the first qubit
        if (M(qs[0]) == Zero)
        {
            if (M(qs[1]) == Zero)
            {
                return 0; 
            }
            else 
            {
                return 1; 
            }
        }
        else 
        {
            if (M(qs[1]) == Zero)
            {
                return 2; 
            }
            else 
            {
                return 3; 
            }
        }
    }
    
    
    // Task 1.7. Distinguish two basis states given by bit strings
    // Inputs:
    //      1) N qubits (stored in an array) which are guaranteed to be
    //         in one of the two basis states described by the given bit strings.
    //      2) two bit string represented as Bool[]s.
    // Output: 0 if qubits were in the basis state described by the first bit string,
    //         1 if they were in the basis state described by the second bit string.
    // Bit values false and true correspond to |0⟩ and |1⟩ states.
    // The state of the qubits at the end of the operation does not matter.
    // You are guaranteed that the both bit strings have the same length as the qubit array,
    // and that the bit strings will differ in at least one bit.
    // You can use exactly one measurement.
    // Example: for bit strings [false, true, false] and [false, false, true]
    //          return 0 corresponds to state |010⟩, and return 1 corresponds to state |001⟩.
    operation TwoBitstringsMeasurement (qs : Qubit[], bits1 : Bool[], bits2 : Bool[]) : Int {
        
        
        for (i in 0 .. Length(qs)-1)
        {
            if (bits1[i] != bits2[i])
            {
                let result = M(qs[i]); 

                if ((result == One && bits1[i]) || 
                    (result == Zero && not bits1[i]))
                {
                    return 0; 
                }
                else 
                {
                    return 1; 
                }
                
            }
        }

        return -1;
    }
    
    
    // Task 1.8. |0...0⟩ state or W state ?
    // Input: N qubits (stored in an array) which are guaranteed to be
    //        either in |0...0⟩ state
    //        or in W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if qubits were in |0...0⟩ state,
    //         1 if they were in W state.
    // The state of the qubits at the end of the operation does not matter.
    operation AllZerosOrWState (qs : Qubit[]) : Int {
        
        for (i in 0 .. Length(qs)-1)
        {
            if (M(qs[i]) == One)
            {
                return 1; 
            }
        }

        return 0;
    }
    
    
    // Task 1.9. GHZ state or W state ?
    // Input: N >= 2 qubits (stored in an array) which are guaranteed to be
    //        either in GHZ state (https://en.wikipedia.org/wiki/Greenberger%E2%80%93Horne%E2%80%93Zeilinger_state)
    //        or in W state (https://en.wikipedia.org/wiki/W_state).
    // Output: 0 if qubits were in GHZ state,
    //         1 if they were in W state.
    // The state of the qubits at the end of the operation does not matter.
    operation GHZOrWState (qs : Qubit[]) : Int {

        let first = M(qs[0]); 

        for (i in 1 .. Length(qs)-1)
        {
            if (M(qs[i]) != first)
            {
                return 1; 
            }
        }

        return 0;
    }
    
    
    // Task 1.10. Distinguish four Bell states
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four Bell states:
    //         |Φ⁺⟩ = (|00⟩ + |11⟩) / sqrt(2)
    //         |Φ⁻⟩ = (|00⟩ - |11⟩) / sqrt(2)
    //         |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2)
    //         |Ψ⁻⟩ = (|01⟩ - |10⟩) / sqrt(2)
    // Output: 0 if qubits were in |Φ⁺⟩ state,
    //         1 if they were in |Φ⁻⟩ state,
    //         2 if they were in |Ψ⁺⟩ state,
    //         3 if they were in |Ψ⁻⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation BellState (qs : Qubit[]) : Int {
        // Hint: you need to use 2-qubit gates to solve this task
        
        // Implements: https://arxiv.org/pdf/quant-ph/0504183.pdf
        
        mutable first = Zero;  
        mutable second = Zero;  

        using (a2 = Qubit[2])
        {
            H(a2[0]); 

            CNOT(a2[0], qs[0]); 
            CNOT(a2[0], qs[1]); 
            H(a2[0]); 

            set first = M(a2[0]); 

            H(qs[0]); 
            H(qs[1]); 
            H(a2[1]); 

            CNOT(a2[1], qs[0]); 
            CNOT(a2[1], qs[1]); 

            H(qs[0]); 
            H(qs[1]); 
            H(a2[1]); 

            set second = M(a2[1]); 

            // Cleanup 
            Reset(a2[0]); 
            Reset(a2[1]); 
        }

        if (first == Zero && second == Zero)
        {
            return 0; 
        }
        elif (first == One && second == Zero)
        {
            return 1; 
        }
        elif (first == Zero && second == One)
        {
            return 2; 
        }
        else 
        {
            return 3; 
        }

        return 0;

    }
    
    
    // Task 1.11*. Distinguish four orthogonal 2-qubit states;
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four orthogonal states:
    //         |S0⟩ = (|00⟩ + |01⟩ + |10⟩ + |11⟩) / 2
    //         |S1⟩ = (|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2
    //         |S2⟩ = (|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2
    //         |S3⟩ = (|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2
    // Output: 0 if qubits were in |S0⟩ state,
    //         1 if they were in |S1⟩ state,
    //         2 if they were in |S2⟩ state,
    //         3 if they were in |S3⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation TwoQubitState (qs : Qubit[]) : Int {
        // ...
        return -1;
    }
    
    
    // Task 1.12**. Distinguish four orthogonal 2-qubit states, part two
    // Input: two qubits (stored in an array) which are guaranteed to be in one of the four orthogonal states:
    //         |S0⟩ = ( |00⟩ - |01⟩ - |10⟩ - |11⟩) / 2
    //         |S1⟩ = (-|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2
    //         |S2⟩ = (-|00⟩ - |01⟩ + |10⟩ - |11⟩) / 2
    //         |S3⟩ = (-|00⟩ - |01⟩ - |10⟩ + |11⟩) / 2
    // Output: 0 if qubits were in |S0⟩ state,
    //         1 if they were in |S1⟩ state,
    //         2 if they were in |S2⟩ state,
    //         3 if they were in |S3⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation TwoQubitStatePartTwo (qs : Qubit[]) : Int {
        // ...
        return -1;
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part II*. Discriminating Nonorthogonal States
    //////////////////////////////////////////////////////////////////
    
    // The solutions for tasks in this section are validated using the following method.
    // The solution is called on N input states, each of which is picked randomly,
    // with all possible input states equally likely to be generated.
    // The accuracy of state discrimination is estimated as an average of
    // discrimination correctness over all input states.
    
    // Task 2.1*. |0⟩ or |+⟩ ?
    //           (quantum hypothesis testing or state discrimination with minimum error)
    // Input: a qubit which is guaranteed to be in |0⟩ or |+⟩ state with equal probability.
    // Output: true if qubit was in |0⟩ state, or false if it was in |+⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    // Note: in this task you have to get accuracy of at least 80%.
    operation IsQubitPlusOrZero (q : Qubit) : Bool {
        // ...
        return true;
    }
    
    
    // Task 2.2**. |0⟩, |+⟩ or inconclusive?
    //             (unambiguous state discrimination)
    // Input: a qubit which is guaranteed to be in |0⟩ or |+⟩ state with equal probability.
    // Output: 0 if qubit was in |0⟩ state,
    //         1 if it was in |+⟩ state,
    //         -1 if you can't decide, i.e., an "inconclusive" result.
    // Your solution:
    //  - can never give 0 or 1 answer incorrectly (i.e., identify |0⟩ as 1 or |+⟩ as 0).
    //  - must give inconclusive (-1) answer at most 80% of the times.
    //  - must correctly identify |0⟩ state as 0 at least 10% of the times.
    //  - must correctly identify |+⟩ state as 1 at least 10% of the times.
    //
    // The state of the qubit at the end of the operation does not matter.
    // You are allowed to use ancilla qubit(s).
    operation IsQubitPlusZeroOrInconclusiveSimpleUSD (q : Qubit) : Int {
        // ...
        return -2;
    }
    
}
