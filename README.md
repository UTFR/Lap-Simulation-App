# Lap-Simulation-App
Lap Simulation Application for development of UTFR vehicles for Formula Student/FSAE Collegiate Design Competitions.

# Motiviation
After intial analysis and fundemental engineering principles outline specific parameters that improve (read: make faster) vehicle performance, it becomes quickly evident that the design of a formula car (or any car, for that matter) is a game of trade offs. Most parameters come with tradeoffs on other parameters. It becomes extremely difficult to determine the best balance of all parameters when the list of parameters becomes long, and complicated. a lap simulation tool allows designers to predict performance trends and base their design decisions with this in mind, giving justification for decisions made at the beginning of the design cycle.

The intent to create an Application that has no code interface is mainly for the design leads within the UTFR organization to have a complete, working tool that they can trust will output sensible numbers and trends, while giving the Vehicle Dynamics team the opportunity to update the code in version releases without having to constantly share the entire source code by compiling it through MATLAB's App Designer. Previous team iterations on laptime code has been notoriously difficult to onboard new members with as the size and scope of the project without help pages or visual references makes the onboarding process much more difficult than necessary.

# Screenshots

![Application Mainpage](https://github.com/UTFR/Lap-Simulation-App/blob/main/homescreenshot.png)

# Current Capabilities (v1.0)
* 2D pseudo-bicycle model steady-state approach
* Custom Tracks via corner/straight data
* Custom 2D graph plotting of all relevant output parameters
* Storable Car and Run data. Shareable and ingestable on any v1.0 application
* loading and viewing of saved cars
