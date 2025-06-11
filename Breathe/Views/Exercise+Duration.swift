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
        
        if add < 0 {
            return decreasingDuration
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
    
    private var decreasingDuration: Int {
        
        var currentIn = self.in
        var currentInHold = self.inHold
        var currentOut = self.out
        var currentOutHold = self.outHold
        
        var totalDuration = currentIn + currentInHold + currentOut + currentOutHold
        
        // For decreasing, diff is from initial to limit (going down)
        let diff = self.initialDynamicDuration - self.limit
        let decrement = -add
        let extraCycle = diff % decrement != 0
        let cycleCount: Int
        if extraCycle {
            cycleCount = diff / decrement + 1
        } else {
            cycleCount = diff / decrement
        }
        
        for i in 0..<cycleCount {
            let toSubtract: Int
            if extraCycle && i == cycleCount-1 {
                // For the last partial cycle, subtract only the remainder
                toSubtract = -(diff % decrement)
            } else {
                toSubtract = add
            }
            
            // Decrease the corresponding phase for the next iteration
            switch dynamicPhase {
            case .in:
                currentIn += toSubtract
            case .inHold:
                currentInHold += toSubtract
            case .out:
                currentOut += toSubtract
            case .outHold:
                currentOutHold += toSubtract
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

extension CustomTrack {
    
    var duration: Int {
        var totalDuration = 0
        for step in steps {
            totalDuration += step.in + step.inHold + step.out + step.outHold
        }
        return totalDuration
    }
}
