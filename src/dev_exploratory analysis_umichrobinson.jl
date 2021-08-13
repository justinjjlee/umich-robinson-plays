using Pkg
using CSV, DataFrames
using Plots, Gadfly, Cairo
theme(:vibrant); # COlor schema
#https://docs.juliaplots.org/latest/generated/plotthemes/
using Statistics, Distributions
using Images, FileIO

str_cd = "C:\\Users\\justi\\Documents\\GitHub\\umich-robinson-plays\\eda\\"
str_cd_dfs = "C:\\Users\\justi\\Documents\\GitHub\\umich-robinson-plays\\data\\"

# ===================================================================================================================
# ===================================================================================================================
# ===================================================================================================================
# ========================================== Duncan Robinson ========================================================
# ===================================================================================================================
# ===================================================================================================================
# ===================================================================================================================
df = CSV.read(str_cd_dfs * "data_duncan_robinson_plays.csv", DataFrame);
# Transform  x - coordinate (long court) symmetric view
df[:, "event_coord_x"] = abs.(df[:, "event_coord_x"] .- 564);
df[df[:, :three_point_shot] .== true, :three_point_shot];

# Exploratory insights
#combine(groupby(df, [:type]), :type => length => :count)
#combine(groupby(df, [:game_id]), :type => length => :count)

df_sub = df[(df.type .== "fieldgoal"), :];
df_sub = df[df[:, :three_point_shot] .== true, :];

# Figure out three-point attempts

# Start with all fieldgoals
df_sub_3pt = df_sub[(df_sub.type .== "fieldgoal"), :]
# COllect three-point attemps and scores
#df_sub_3pt = df_sub[contains.(df_sub[:, "event_description"], "three"), :];
df_sub_3pt[:, "pointmade"] .= 0;
#df_sub_3pt[contains.(df_sub_3pt[:, "event_description"], "makes"), "pointmade"] .= 1;
df_sub_3pt[.!ismissing.(df_sub_3pt.points_scored .== 3), "pointmade"] .= 1;

# Full court
xtiksall = [-120, 525, 1140]
labelsxall = Dict(zip(xtiksall, ["baseline", "midcourt", "baseline"]))
# Half court
xtiks = [100, 525]
labelsx = Dict(zip(xtiks, ["midcourt", "baseline"]))

ytiks = [-50, 275, 580]
labelsy = Dict(zip(ytiks, ["right", "center", "left"]))

df_plt_3ptyes = df_sub_3pt[(df_sub_3pt.pointmade .== 1), ["event_coord_x", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptyes[:, 1], y=df_plt_3ptyes[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                      Coord.cartesian(xmin=xtiks[1], xmax=xtiks[2], ymin=ytiks[1], ymax=ytiks[3]),
                      Guide.xticks(ticks = xtiks), Guide.xlabel("Half-court (standardized)"), 
                      Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                      Scale.x_continuous(labels = x -> labelsx[x]),
                      Scale.y_continuous(labels = x -> labelsy[x]),
                      #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                      Theme(background_color = nothing))
img = PNG(str_cd * "plt_3pt_scores_robinson.png", 18cm, 18cm)
draw(img, plt_3ptattempt)


df_plt_3ptatmt = df_sub_3pt[:, ["event_coord_x", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptatmt[:, 1], y=df_plt_3ptatmt[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                              Coord.cartesian(xmin=xtiks[1], xmax=xtiks[2], ymin=ytiks[1], ymax=ytiks[3]),
                              Guide.xticks(ticks = xtiks), Guide.xlabel("Half-court (standardized)"), 
                              Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                              Scale.x_continuous(labels = x -> labelsx[x]),
                              Scale.y_continuous(labels = x -> labelsy[x]),
                              #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                              Theme(background_color = nothing))
img = PNG(str_cd * "plt_3pt_attempt_robinson.png", 18cm, 18cm)
draw(img, plt_3ptattempt)

# ===================================================================================================================
# ===================================================================================================================
# ===================================================================================================================
# ========================================== NCAA Statistics ========================================================
# ===================================================================================================================
# ===================================================================================================================
# ===================================================================================================================
df_all = CSV.read(str_cd_dfs * "data_all_plays.csv", DataFrame);

df_all[:, "event_coord_x_half"] = abs.(df_all[:, "event_coord_x"] .- 564);
# Data cleaning process

df_all[:, "event_coord_x_adj"] .= round.(Int, df_all.event_coord_x./10)*10;
df_all[:, "event_coord_y_adj"] .= round.(Int, df_all.event_coord_y./10)*10;
# Mark if points are made
df_all[:, "pointmade"] .= 0;
df_all[.!ismissing.(df_all.points_scored .== 3), "pointmade"] .= 1;

df_all_adj = combine(groupby(df_all, ["event_coord_x_adj", "event_coord_y_adj"]), :three_point_shot => sum => :temp_num_attempt);
# Evaluate what coordinates are giving min value issues
describe(df_all_adj, :min, :max, :q25, :median, cols = :temp_num_attempt);
# Select those aggregated coordinate that does not have much of attempts
df_row_remove = df_all_adj[df_all_adj[:, :temp_num_attempt] .>= 7, :];

df_all_filtered = rightjoin(df_all, df_row_remove, on = [:event_coord_x_adj, :event_coord_y_adj]);
df_all_filteredout = leftjoin(df_all, df_row_remove, on = [:event_coord_x_adj, :event_coord_y_adj]);

df_sub_all = df_all_filtered[df_all_filtered[:, :three_point_shot] .== true, :];


#Explanatory plot
df_plt_3ptyes = df_sub_all[(df_sub_all.pointmade .== 1), ["event_coord_x", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptyes[:, 1], y=df_plt_3ptyes[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                      Coord.cartesian(xmin=xtiksall[1], xmax=xtiksall[3], ymin=ytiks[1], ymax=ytiks[3]),
                      Guide.xticks(ticks = xtiksall), Guide.xlabel("Full court"), 
                      Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                      Scale.x_continuous(labels = x -> labelsxall[x]),
                      Scale.y_continuous(labels = x -> labelsy[x]),
                      #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                      Theme(background_color = nothing))
img = PNG(str_cd * "plt_3pt_scores_all_fullcourt_ncaa.png", 13cm, 9cm)
draw(img, plt_3ptattempt)

#Alternate option to be save with image

img_path = str_cd*"basketball_halfcourt.png"
img = load(img_path)

df_plt_3ptatmt = df_sub_all[:, ["event_coord_x_half", "event_coord_y"]];
plt_img = Plots.plot([0, 535], [-20, 620], reverse(img, dims = 1), yflip = false, aspect_ratio = :none, showaxis = false)
histogram2d!(df_plt_3ptatmt[:, 1], df_plt_3ptatmt[:, 2], bins = 65, showaxis = false, ticks = false, normed = false, aspect_ratio = 1)
annotate!([(-10,570,text("Three-pooint attempts", 13, :left, :top, :blue))])
savefig(plt_img, str_cd * "shot_attempts.png") # save the fig referenced by plot_ref as fn


df_plt_3ptyes = df_sub_all[(df_sub_all.pointmade .== 1), ["event_coord_x_half", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptyes[:, 1], y=df_plt_3ptyes[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                      Coord.cartesian(xmin=xtiks[1], xmax=xtiks[2], ymin=ytiks[1], ymax=ytiks[3]),
                      Guide.xticks(ticks = xtiks), Guide.xlabel("Half-court (standardized)"), 
                      Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                      Scale.x_continuous(labels = x -> labelsx[x]),
                      Scale.y_continuous(labels = x -> labelsy[x]),
                      #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                      Theme(background_color = nothing))
img = PNG(str_cd * "plt_3pt_scores_all_ncaa.png", 18cm, 18cm)
draw(img, plt_3ptattempt)


df_plt_3ptatmt = df_sub_all[:, ["event_coord_x_half", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptatmt[:, 1], y=df_plt_3ptatmt[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                              Coord.cartesian(xmin=xtiks[1], xmax=xtiks[2], ymin=ytiks[1], ymax=ytiks[3]),
                              Guide.xticks(ticks = xtiks), Guide.xlabel("Half-court (standardized)"), 
                              Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                              Scale.x_continuous(labels = x -> labelsx[x]),
                              Scale.y_continuous(labels = x -> labelsy[x]),
                              #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                              Theme(background_color = nothing))
img = PNG(str_cd * "plt_3pt_attempt_all_ncaa.png", 18cm, 18cm)
draw(img, plt_3ptattempt)


#=
# THose shots that are made across the half court
condition_1 = (((df_all.team_basket .== "left") .& (df_all.event_coord_x .> 564)) .| 
                               ((df_all.team_basket .== "right") .& (df_all.event_coord_x .< 564)))

suspected_hailmarry =  df_all[condition_1, :]

suspected_hailmarry[:, "pointmade"] .= 0;
suspected_hailmarry[.!ismissing.(suspected_hailmarry.points_scored .== 3), "pointmade"] .= 1;

# Start with all fieldgoals
suspected_hailmarry = suspected_hailmarry[(suspected_hailmarry.type .== "fieldgoal"), :]



df_plt_3ptyes = suspected_hailmarry[(suspected_hailmarry.pointmade .== 1), ["event_coord_x", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptyes[:, 1], y=df_plt_3ptyes[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                      Coord.cartesian(xmin=xtiksall[1], xmax=xtiksall[3], ymin=ytiks[1], ymax=ytiks[3]),
                      Guide.xticks(ticks = xtiksall), Guide.xlabel("Full court"), 
                      Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                      Scale.x_continuous(labels = x -> labelsxall[x]),
                      Scale.y_continuous(labels = x -> labelsy[x]),
                      #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                      Theme(background_color = nothing))

df_all[((((df_all.team_basket .== "left") .& (df_all.event_coord_x .> 564)) .| 
        ((df_all.team_basket .== "right") .& (df_all.event_coord_x .< 564))) .& 
        df_all.three_point_shot .== true) .| 
        (abs.(df_all.event_coord_x .- 525) .< 100), :event_coord_x] .= 525
=#