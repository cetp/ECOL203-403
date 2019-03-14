; Black screen in the interface tab: the Netlogo world, made up of agents.
; Agents types: observer, patches, turtles
; observer: he sees everything and he can change a variable in an observer (global) context.
; patches: the world is divided in several small square called patches. Patches can't move and they are identified with coordinates.
; turtles: the observer or patches can create turtles. They can move and they are identified by a number.
; Agents variables: location where the values are stored.
; Agents variables types: global, patch, turtle, link, local.


breed [predators predator]
;Creation of the predator breed, a new type of turtles.
breed [prey a-prey]
;Creation of the prey breed, another new type of turtles.
predators-own[RPenergy dist P-age]
;Creation of 4 turtle variables for predators.
prey-own[RNenergy dist N-age]
;Creation of 3 turtle variables for prey.
globals [predators-dead prey-dead Nborn Pborn Nfactorsize Pfactorsize x y c1 c2]
;Creation of 6 globals variables.

;Sense of the names:
;predators-own:
;RPenergy    <-> energy that need Predator to Reproduce.
;dist        <-> distance between a predator and a prey
;P-age       <-> age in computer language (number of ticks) of the Predators

;prey-own:
;RNenergy    <-> energy that need prey to Reproduce.
;dist        <-> distance between a predator and a prey
;N-age       <-> age in computer language  (number of ticks) of the Prey


;globals: create in the Code
;predators-dead   <-> number of predators who are dead since the beginning of the simulation
;prey-dead        <-> number of prey who are dead since the beginning of the simulation
;Nborn            <-> number of prey who are born since the beginning of the simulation
;Pborn            <-> number of Predator who are born since the beginning of the simulation
;Nfactorsize      <-> a number to keep a value near 11 for the size of the prey whatever their energy.
;Pfactorsize      <-> a number to keep a value near 11 for the size of the Predators whatever their energy.

;globals: create in the Interface Buttons
;Pred_number_initial
;prey_speed
;prey_speed
; etc ...

to Setup
   ;run the following code in the bottom named setup of the interface
   clear-all
   ;remove all the world
   setup-world-shape
   ;create a procedure named setup-world-shape to clarify the code: the code in this procedure change the shape of the world.
   setup-landscape
   ;create a procedure named setup-landscape to clarify the code which will create the landscape of the world.
   setup-predators
   ;create a procedure named setup-predators which will create the predators
   setup-prey
   ;create a procedure named setup-prey which will create the prey
   reset-ticks
   ;ticks <- 0
   display
   ;display the following code on the black screen
end

to setup-world-shape
;run the following code in -to setup-
;   set-patch-size 0.00000000000001
   ;the size of patches is now 0.00000000000001
 end

to setup-landscape
;run the following code in -to setup-
   ask patches with [pxcor > -170 and pxcor < 60 and pycor > -50 and pycor < 50] [ask turtles-here [set hidden? true]]
   ;the turtles precedently create are hidden from the black screen if they are situated in the center of the black screen, it's for the red sentence "sorry, you are dead" can be clearly lisible.
   ask patches [set pcolor 68]
   ;the observer asks patches to turn green
end




to setup-predators
;run the following code in -to setup-
   set-default-shape predators "cat"
   ;a predator will have a wolf shape by default.
   set Pfactorsize 1 + abs (Pred_energy_to_reproduce - 10) / 5
   ;Pfactorsize = valeur absolue de ("Pred_energy_to_reproduce" - 10) / 10
   create-predators Pred_number_initial [setxy random-xcor random-ycor
                                         set color black
                                         set RPenergy 1
                                         set P-age random (15 + round (random (3) - random (3))) * 100
                                         set size 12 + RPenergy * Pfactorsize]
;create "Pred_number_initial" turtles type predators [of random coordinate in the world
                                                          ;with a black color
                                                          ;with the minimum value of energy
                                                          ;with a random value of P-age in [0, ("Pred_energy_to_reproduce" + or - a random value in [0, 4]) * 100]
                                                          ;with the size = 12 + RPenergy * Pfactorsize]

end




to setup-prey
;run the following code in -to setup-
    set-default-shape prey "bird"
    ;a prey will have a sheep shape by default.
    set Nfactorsize 1 + abs (Prey_energy_to_reproduce - 10) / 5
    ;Nfactorsize = valeur absolue de ("sheep-energy_to-reproduce" - 10) / 10
    create-prey Prey_number_initial [setxy random-xcor random-ycor
                                        set color 106
                                        set RNenergy 1
                                        set N-age random (15 + round (random (3) - random (3))) * 100
                                        set size 11 + RNenergy * Nfactorsize]
     ;create "Prey_number_initial" turtles type prey [of random coordinate in the world
                                                ;with a white color
                                                ;with the minimum value of energy
                                                ;with a random value of N-age in [0, ("Prey_energy_to_reproduce" + or - a random value in [0, 14]) * 100]
                                                ;size <- 11 + RNenergy * Nfactorsize]
 end



to GO
  if ticks > Max_simulation_duration [
    output-print "Both the predators and prey survived until the end of the simulation."
    stop]
;run the following code in the bottom named GO of the interface
   GO-movement
   ;create a procedure named GO-movement to clarify the code
   GO-Reproduction
   ;create a procedure named GO-R to clarify the code
   GO-death
   ;create a procedure named GO-death to clarify the code
   if count prey = 0 [clear-output
                      output-print "All the prey are dead."
                      output-print "The predators all go extinct shortly afterwards."
    output-print "The simulation is finished."
                      stop]
   ;stop the simulation if all the prey are dead
   if count predators = 0 [clear-output
                           output-print "All the predators are dead."
                           output-print "The prey go on to cover the earth."
                           output-print "The simulation is finished."
                           stop]
   ;stop the simulation if all the predators are dead
   if ticks = 3 [clear-output]
   ;clear the text message in the Interface tab if the number of ticks is egal to 3
   tick

   ;ticks <- ticks + 1
end




to GO-movement
;run the following code in -GO-
   foreach sort predators [ ?1 -> ask prey [set dist distance ?1]
                           ask prey with-min [dist][ifelse dist < Search_distance *  15
                                                          [ifelse dist < Catch_distance  * 15
                                                                [set color red
                                                                ask ?1 [set RPenergy RPenergy + 1]]
                                                                [ask ?1 [face one-of prey with-min [dist]
                                                                        lt random 25 rt random 25
                                                                        forward Pred_speed]]]
                                                    [ask ?1 [right random 50
                                                            left random  50
                                                            forward Pred_speed
                                                            ]]]
                           ask ?1 [set P-age P-age + 1
                                  set size 12 + RPenergy * Pfactorsize ] ]
   ;foreach item in the list [(predator 0) (predator 1) (predator 2) ... (the last predator)] [ask all the prey [dist <- distance between predator 0 and them (dist is a prey variable like size but introduced by me in the code), ? take the value (predator 0) and run all the code in the [] of foreach sort prey [] then ? <- (predator 1) and repeat again all the code in the [] of foreach sort prey [], and so on]
                                                                                              ;ask prey which has the minimum dist [if dist of this prey < Search_distance * Catch_distance (in this case there is a single value possible of the minimum dist because the world is big, I can't wrote ask a-prey with-min [] because with-min works with agentset only)
                                                                                              ;[if dist < Catch_distance
                                                                                              ;[the prey turns red
                                                                                               ;if the switcher blood in the interface tab is on On [creation of the local variable x which exists just in this [] and take a random value in [0, 1]
                                                                                              ;ask patches in the radius (3 + random 4)[take a color (red - x - 2)], pcolor is the color variable of patches, for turtles it's just color]
                                                                                             ;ask predator 0 [set his value of RPenergy to the value RPenergy + 1, when I create the Predator variable RPenergy, it takes the value 0 by default. So this variable counts the number of prey that have ate each predators.]]
                                                                                              ;[if dist < Catch_distance is wrong, ask predator 0 [turn toward one of the prey which have the minimum value of dist by changing his variable called heading, I have to introduce one-of because even if prey with-min [dist] is an agentset which contains only one item, it's still an agentset and face can't accept agenset.
                                                                                                ;move forward Pred_speed patch]]]
                                                                                                ;[if dist of this prey < Search_distance is wrong, ask predator 0 [turn toward right with a random degree in [0, 49] <-> heading <- heading + random 50
                                                                                                                                                                                                                                         ;turn toward left with a random degree in [0, 49] <-> heading <- heading - random 50
                                                                                                                                                                                                                                         ;move forward Pred_speed patch

                                                                                              ;ask predator 0 [set P-age P-age + 1
                                                                                                              ;set size 12 + RPenergy * Pfacorize (more predator 0 has energy, more he is big)]]
   foreach sort prey [ ?1 -> ask predators [set dist distance ?1]
                      ask predators with-min [dist] [ifelse dist < Dodge_distance * 4 + 11
                                                             [ask ?1 [set heading [heading] of one-of predators with-min [dist] lt random 35 rt random 35  fd prey_speed ]]
                                                             [ask ?1 [right random 50
                                                                     left random  50
                                                                     forward prey_speed]]]
                      ask prey with [distance ?1 < 100] [ifelse 0.8 = 0
                                                             []
                                                             [ifelse (distance ?1 < 10) and (RNenergy >=  1)
                                                                      [ask ?1 [ set RNenergy RNenergy - 0.09]]
                                                                      [ifelse (distance ?1 < 30) and (RNenergy  >=  1 )
                                                                            [ask ?1 [ set RNenergy RNenergy - 0.0045]]
                                                                            [ifelse (distance ?1 < 50) and (RNenergy   >=  1)
                                                                                  [ask ?1 [ set RNenergy RNenergy - 0.00306]]
                                                                                  [ifelse (distance ?1 < 100) and (RNenergy   >=  1)
                                                                                        [ask ?1 [ set RNenergy RNenergy - 0.00234]]
                                                                                        [set size 11 ]]]]]]
                      ask ?1 [set RNenergy RNenergy + 0.1
                             set N-age N-age + 1
                             set size 11 + (RNenergy  * Nfactorsize) ] ]
   ;foreach item in the list [(prey 0) (prey 1) (prey 2) ... (the last prey)][for each predator, their value of dist take the value of the distance between them and ? (? refers to an item in the list)
                                                                             ;[ask each predator who has the minimum distance with them and ? [if this distance is inferior to Dodge_distance * Catch_distance
                                                                                                                                                 ;[the prey run away, if random 100 > 97.7, the predator who hunts him moves slowly in a random way for a while and the prey succeded his run-away] ]
                                                                                                                                                 ;[if not the prey move in a random way.]
                                                                             ;NOW pre-dd is set to 0.8. no need for students to fiddle with it. if prey-dd = 0 then nothing is done , if not then more they are prey near ?, more the RNenergy of ? decreases. if RNEnergy < 1 of ? then Rnenergy <- 1.
                                                                             ;ask prey ? [;set RNenergy RNenergy + 0.1 (imagine it's the energy taken by prey from grass)
                                                                                          ;set N-age N-age + 1
                                                                                          ;set size 12 + RNenergy * Nfacorize (more predator 0 has energy, more he is big)]]

end


to GO-death
;run the following code in -GO-
    foreach sort prey [ ?1 -> ask ?1 [if (color = red) [ask ?1 [set prey-dead  prey-dead +  1
                                                                      die]]] ]
   ;prey-dead count the number of prey who are dead since the begining of the simulation, this code is used in the monitor "Prey number dead" in the Interface tab.
   foreach sort predators[ ?1 -> ask ?1 [if  random-float 101 < Pred_prob_death [ask ?1 [set predators-dead predators-dead + 1
           die]]] ]
   ;predators-dead count the number of prey who are dead since the begining of the simulation, this code is used in the monitor "Predators number dead" in the Interface tab.
end




to GO-Reproduction
;run the following code in -GO-
   foreach sort predators [ ?1 -> if [Pred_energy_to_reproduce] of ?1 < [RPenergy] of ?1 [ask ?1 [hatch 1 [set P-age 0
                                                                                                      set RPenergy 1
                                                                                                      set Pborn Pborn + 1]
                                                                                      set RPenergy 1]] ]
   foreach sort prey [ ?1 -> if [Prey_energy_to_reproduce ] of ?1 < [RNenergy] of ?1 [ask ?1 [hatch 1 [set N-age 0
                                                                                             set RNenergy 1
                                                                                             set Nborn Nborn + 1
                                                                                             set label ""
                                                                                             set label-color 33]
                                                                                    set RNenergy 1]] ]
  ;hatch: a new turtle born in the same place of its parent, its caracteristics are the same of the parent by default. The structure of the procedure hatch is:  hatch [change caracteristics of this baby].
  ;the code: set label "" allow a-prey (Pred_number_initial + 23) to hatch one prey without your name in label.
end
@#$#@#$#@
GRAPHICS-WINDOW
680
10
1193
524
-1
-1
1.008
1
10
1
1
1
0
1
1
1
0
500
0
500
0
0
1
Time
30.0

BUTTON
405
85
515
141
Setup
setup\n\n;setup: button to initialize the world,\n;run the code related to \"to setup\"\n;in the tab \"code\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
525
85
655
140
Start/Stop
GO\n\n;GO: button to start the simulation:\n;run the code related to \"to GO\" in the tab \"code\".\n\n;forever (checked): the code related to \"to GO\"\n;runs in loop until you click again on GO.\n\n;Disable until ticks start(checked):\n;prevent the user to start the simulation without\n;initialize the world (the ticks starts by taking\n;any value and the code related to \"to setup\"\n;put the value 0 to tick).
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
0
110
185
143
Pred_speed
Pred_speed
0
100
4.7
0.1
1
NIL
HORIZONTAL

SLIDER
210
110
393
143
Prey_speed
Prey_speed
0
100
47.0
0.1
1
NIL
HORIZONTAL

SLIDER
0
230
185
263
Pred_energy_to_reproduce
Pred_energy_to_reproduce
2
10
6.0
0.1
1
NIL
HORIZONTAL

SLIDER
210
230
390
263
Prey_energy_to_reproduce
Prey_energy_to_reproduce
0.2
10
1.2
0.1
1
NIL
HORIZONTAL

SLIDER
0
195
185
228
Catch_distance
Catch_distance
0
20
1.8
0.1
1
NIL
HORIZONTAL

SLIDER
0
162
185
195
Search_distance
Search_distance
0
20
1.1
0.1
1
NIL
HORIZONTAL

SLIDER
210
162
393
195
Dodge_distance
Dodge_distance
0
20
9.6
0.1
1
NIL
HORIZONTAL

SLIDER
0
55
185
88
Pred_number_initial
Pred_number_initial
1
200
13.0
1
1
NIL
HORIZONTAL

SLIDER
210
55
393
88
Prey_number_initial
Prey_number_initial
1
200
32.0
1
1
NIL
HORIZONTAL

MONITOR
470
385
655
430
Current pred. population size
count predators
17
1
11

MONITOR
470
545
655
590
Current prey population size
count prey
17
1
11

MONITOR
470
429
655
474
Number of predators that died
predators-dead
17
1
11

MONITOR
470
590
655
635
Number of prey that died
prey-dead
17
1
11

MONITOR
470
471
655
516
Number of predators born
Pborn
17
1
11

MONITOR
470
635
655
680
Number of prey born
Nborn
17
1
11

SLIDER
0
265
185
298
Pred_prob_death
Pred_prob_death
0
1
0.58
0.01
1
NIL
HORIZONTAL

TEXTBOX
410
10
645
80
1. Click 'Setup' to initialize a simulation.\n2. Click Start/Stop to begin or stop a simulation.\n\n
14
0.0
1

OUTPUT
405
145
655
285
12

INPUTBOX
125
305
275
365
Max_simulation_duration
10000.0
1
0
Number

TEXTBOX
215
10
395
66
Prey parameters\n______________________
16
0.0
1

TEXTBOX
5
10
205
66
Predator parameters\n______________________
16
0.0
1

TEXTBOX
5
340
640
380
Outputs\n_________________________________________________________________________
16
0.0
1

PLOT
5
380
465
680
Population dynamics of predators and prey
Time
Population size
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Predators" 1.0 0 -16777216 true "" "plot count predators"
"Prey" 1.0 0 -8020277 true "" "plot count prey"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bird
false
0
Polygon -7500403 true true 135 165 90 270 120 300 180 300 210 270 165 165
Rectangle -7500403 true true 120 105 180 237
Polygon -7500403 true true 135 105 120 75 105 45 121 6 167 8 207 25 257 46 180 75 165 105
Circle -16777216 true false 128 21 42
Polygon -7500403 true true 163 116 194 92 212 86 230 86 250 90 265 98 279 111 290 126 296 143 298 158 298 166 296 183 286 204 272 219 259 227 235 240 241 223 250 207 251 192 245 180 232 168 216 162 200 162 186 166 175 173 171 180
Polygon -7500403 true true 137 116 106 92 88 86 70 86 50 90 35 98 21 111 10 126 4 143 2 158 2 166 4 183 14 204 28 219 41 227 65 240 59 223 50 207 49 192 55 180 68 168 84 162 100 162 114 166 125 173 129 180

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

cat
false
0
Line -7500403 true 285 240 210 240
Line -7500403 true 195 300 165 255
Line -7500403 true 15 240 90 240
Line -7500403 true 285 285 195 240
Line -7500403 true 105 300 135 255
Line -16777216 false 150 270 150 285
Line -16777216 false 15 75 15 120
Polygon -7500403 true true 300 15 285 30 255 30 225 75 195 60 255 15
Polygon -7500403 true true 285 135 210 135 180 150 180 45 285 90
Polygon -7500403 true true 120 45 120 210 180 210 180 45
Polygon -7500403 true true 180 195 165 300 240 285 255 225 285 195
Polygon -7500403 true true 180 225 195 285 165 300 150 300 150 255 165 225
Polygon -7500403 true true 195 195 195 165 225 150 255 135 285 135 285 195
Polygon -7500403 true true 15 135 90 135 120 150 120 45 15 90
Polygon -7500403 true true 120 195 135 300 60 285 45 225 15 195
Polygon -7500403 true true 120 225 105 285 135 300 150 300 150 255 135 225
Polygon -7500403 true true 105 195 105 165 75 150 45 135 15 135 15 195
Polygon -7500403 true true 285 120 270 90 285 15 300 15
Line -7500403 true 15 285 105 240
Polygon -7500403 true true 15 120 30 90 15 15 0 15
Polygon -7500403 true true 0 15 15 30 45 30 75 75 105 60 45 15
Line -16777216 false 164 262 209 262
Line -16777216 false 223 231 208 261
Line -16777216 false 136 262 91 262
Line -16777216 false 77 231 92 261

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rabbit
false
0
Polygon -7500403 true true 61 150 76 180 91 195 103 214 91 240 76 255 61 270 76 270 106 255 132 209 151 210 181 210 211 240 196 255 181 255 166 247 151 255 166 270 211 270 241 255 240 210 270 225 285 165 256 135 226 105 166 90 91 105
Polygon -7500403 true true 75 164 94 104 70 82 45 89 19 104 4 149 19 164 37 162 59 153
Polygon -7500403 true true 64 98 96 87 138 26 130 15 97 36 54 86
Polygon -7500403 true true 49 89 57 47 78 4 89 20 70 88
Circle -16777216 true false 37 103 16
Line -16777216 false 44 150 104 150
Line -16777216 false 39 158 84 175
Line -16777216 false 29 159 57 195
Polygon -5825686 true false 0 150 15 165 15 150
Polygon -5825686 true false 76 90 97 47 130 32
Line -16777216 false 180 210 165 180
Line -16777216 false 165 180 180 165
Line -16777216 false 180 165 225 165
Line -16777216 false 180 210 210 240

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
