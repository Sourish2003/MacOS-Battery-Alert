-- MacOS Battery Alert Script (Plain Text Version)
-- Monitors battery level and sends notifications at 20% and 80%
-- Compatible with macOS 12+ (Monterey, Ventura, Sonoma, Sequoia, and future versions)

try
	-- Get power source information
	set powerInfo to (do shell script "pmset -g ps")
	
	-- Check if we're on AC power or battery
	set isOnACPower to (powerInfo contains "AC Power")
	
	-- Extract battery percentage
	set batteryPercent to (do shell script "pmset -g batt | grep -Eo \"[0-9]+%\" | head -1 | cut -d% -f1") as integer
	
	-- Smart notification logic
	if isOnACPower then
		-- On AC Power: Check for 80% to suggest unplugging
		if batteryPercent ≥ 80 then
			-- Check if we just crossed the 80% threshold to avoid spam
			set lastCheck to my readLastPercentage()
			if lastCheck < 80 then
				display notification "Battery reached 80%. Consider unplugging to preserve battery health." with title "🔋 Optimal Charge Level" sound name "Hero"
				my writeLastPercentage(batteryPercent)
			end if
		else
			-- Reset the flag when below 80%
			my writeLastPercentage(batteryPercent)
		end if
	else
		-- On Battery Power: Check for 20% to suggest plugging in
		if batteryPercent ≤ 20 then
			-- Check if we just crossed the 20% threshold to avoid spam
			set lastCheck to my readLastPercentage()
			if lastCheck > 20 then
				display notification "Battery at " & batteryPercent & "%. Please connect charger." with title "⚠️ Low Battery Warning" sound name "Ping"
				my writeLastPercentage(batteryPercent)
			end if
		else
			-- Reset the flag when above 20%
			my writeLastPercentage(batteryPercent)
		end if
	end if
	
on error errorMessage
	-- Log errors for debugging
	do shell script "echo '[" & (current date) & "] Battery Alert Error: " & errorMessage & "' >> ~/Library/Logs/BatteryAlert.log"
end try

-- Helper function to read last percentage to prevent notification spam
on readLastPercentage()
	try
		set lastPercent to (do shell script "cat ~/Library/Application\\ Support/BatteryAlert/last_percent.txt 2>/dev/null || echo '50'") as integer
		return lastPercent
	on error
		return 50 -- Default safe value
	end try
end readLastPercentage

-- Helper function to write current percentage
on writeLastPercentage(percent)
	try
		do shell script "mkdir -p ~/Library/Application\\ Support/BatteryAlert && echo " & percent & " > ~/Library/Application\\ Support/BatteryAlert/last_percent.txt"
	on error
		-- Silently fail if we can't write
	end try
end writeLastPercentage