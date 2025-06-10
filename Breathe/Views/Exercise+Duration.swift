
extension Exercise {
    var duration: Int {
        return 0
    }
}

extension ConstantTrack {
    var duration: Int {
        if isInfinite {
            return 0
        }
        
        let singleCycleDuration = `in` + inHold + out + outHold
        return singleCycleDuration * repeatTimes
    }
}

extension DynamicTrack {
    
    var duration: Int {
        if add > 0 {
            return increasingDuration
        }
        
        return 0
    }
    
    private var increasingDuration: Int {
        
        var currentIn = self.in
        var currentInHold = self.inHold
        var currentOut = self.out
        var currentOutHold = self.outHold
        
        var totalDuration = currentIn + currentInHold + currentOut + currentOutHold
        
        let diff = self.limit - self.initialDynamicDuration
        let extraCycle = diff % add != 0
        let cycleCount: Int
        if extraCycle {
            cycleCount = diff / add + 1
        } else {
            cycleCount = diff / add
        }
        
        for i in 0..<cycleCount {
            let toAdd: Int
            if extraCycle && i == cycleCount-1 {
                // For the last partial cycle, add only the remainder
                toAdd = diff % add
            } else {
                toAdd = add
            }
            
            // Increase the corresponding phase for the next iteration
            switch dynamicPhase {
            case .in:
                currentIn += toAdd
            case .inHold:
                currentInHold += toAdd
            case .out:
                currentOut += toAdd
            case .outHold:
                currentOutHold += toAdd
            }
            
            // Add the current cycle duration
            totalDuration += currentIn + currentInHold + currentOut + currentOutHold
        }
        
        return totalDuration
    }
    
    private var initialDynamicDuration: Int {
        switch dynamicPhase {
        case .in:
            self.in
        case .inHold:
            self.inHold
        case .out:
            self.out
        case .outHold:
            self.outHold
        }
    }
    
}
