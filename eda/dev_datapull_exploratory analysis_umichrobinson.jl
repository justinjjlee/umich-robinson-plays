using Pkg
using CSV, DataFrames
using Plots, Gadfly, Cairo
theme(:vibrant); # COlor schema
#https://docs.juliaplots.org/latest/generated/plotthemes/
using Statistics, Distributions
using Images, FileIO

str_cd = "C:\\Users\\justi\\Documents\\GitHub\\umich-robinson-plays\\eda\\"
str_cd_dfs = "C:\\Users\\justi\\Documents\\GitHub\\umich-robinson-plays\\data\\"

df = CSV.read(str_cd_dfs * "data_duncan_robinson_plays.csv", DataFrame);
#df_pt1 = df[:, [:game_id, :scheduled_date, :attendance, :venue_capacity, :tournament, :tournament_type, :period, :game_clock, :elapsed_time_sec, :event_description, :event_coord_x, :event_coord_y, :type]]

# Transform  x - coordinate (long court) symmetric view
df[:, "event_coord_x"] = abs.(df[:, "event_coord_x"] .- 564);
df[df[:, :three_point_shot] .== true, :three_point_shot];

# Exploratory insights

#combine(groupby(df, [:type]), :type => length => :count)
#combine(groupby(df, [:game_id]), :type => length => :count)

df_sub = df[(df.type .== "fieldgoal"), :];
df_sub = df[df[:, :three_point_shot] .== true, :];
#df_sub[:, "event_description"]
#df[(df.type .== "threepointmade"), "event_description"]

# Figure out three-point attempts

# Start with all fieldgoals
df_sub_3pt = df_sub[(df_sub.type .== "fieldgoal"), :]
# COllect three-point attemps and scores
#df_sub_3pt = df_sub[contains.(df_sub[:, "event_description"], "three"), :];
df_sub_3pt[:, "pointmade"] .= 0;
#df_sub_3pt[contains.(df_sub_3pt[:, "event_description"], "makes"), "pointmade"] .= 1;
df_sub_3pt[.!ismissing.(df_sub_3pt.points_scored .== 3), "pointmade"] .= 1;




xtiks = [100, 525]
labelsx = Dict(zip(xtiks, ["midcourt", "baseline"]))

ytiks = [-50, 275, 600]
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
img = PNG(str_cd * "plt_3pt_scores.png", 18cm, 18cm)
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
img = PNG(str_cd * "plt_3pt_attempt.png", 18cm, 16cm)
draw(img, plt_3ptattempt)















df_all = CSV.read(str_cd_dfs * "data_all_plays.csv", DataFrame);
# NEW: for those events happening on the opposite end of the court, 
#  for now, change those to the mid-court activities.
df_all[((df_all.team_basket .== "left") .& (df_all.event_coord_x .> 564) .| 
        (df_all.team_basket .== "right") .& (df_all.event_coord_x .< 564)
       ), :event_coord_x] .= 564


df_all[:, "event_coord_x"] = abs.(df_all[:, "event_coord_x"] .- 564);
df_sub_all = df_all[df_all[:, :three_point_shot] .== true, :];


df_sub_all[:, "pointmade"] .= 0;
df_sub_all[.!ismissing.(df_sub_all.points_scored .== 3), "pointmade"] .= 1;

# Start with all fieldgoals
df_sub_all = df_sub_all[(df_sub_all.type .== "fieldgoal"), :]


df_plt_3ptyes = df_sub_all[(df_sub_all.pointmade .== 1), ["event_coord_x", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptyes[:, 1], y=df_plt_3ptyes[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                      Coord.cartesian(xmin=xtiks[1], xmax=xtiks[2], ymin=ytiks[1], ymax=ytiks[3]),
                      Guide.xticks(ticks = xtiks), Guide.xlabel("Half-court (standardized)"), 
                      Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                      Scale.x_continuous(labels = x -> labelsx[x]),
                      Scale.y_continuous(labels = x -> labelsy[x]),
                      #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                      Theme(background_color = nothing))
img = PNG(str_cd * "plt_3pt_scores_all.png", 18cm, 18cm)
draw(img, plt_3ptattempt)


df_plt_3ptatmt = df_sub_all[:, ["event_coord_x", "event_coord_y"]];
plt_3ptattempt = Gadfly.plot(x=df_plt_3ptatmt[:, 1], y=df_plt_3ptatmt[:, 2], Geom.hexbin(xbincount=20, ybincount=20), 
                              Coord.cartesian(xmin=xtiks[1], xmax=xtiks[2], ymin=ytiks[1], ymax=ytiks[3]),
                              Guide.xticks(ticks = xtiks), Guide.xlabel("Half-court (standardized)"), 
                              Guide.yticks(ticks = ytiks), Guide.ylabel(""),
                              Scale.x_continuous(labels = x -> labelsx[x]),
                              Scale.y_continuous(labels = x -> labelsy[x]),
                              #Guide.xticks(ticks=nothing, label = false), Guide.yticks(ticks=nothing),
                              Theme(background_color = nothing))
img = PNG(str_cd * "plt_3pt_attempt_all.png", 18cm, 16cm)
draw(img, plt_3ptattempt)





minimum(df_all.event_coord_x)
maximum(df_all.event_coord_x)

df_sub_all[:, 55:end]

unique(df_sub_all.three_point_shot)


evaltst = df_sub_all[((abs.(df_sub_all.event_coord_y .- 275) .< 100) .& (df_sub_all.event_coord_x .> 300)), :]




evaltst[:, 50:end]

# THERE ARE THOSE THAT THROWS THREE POINTER way off from the court








df_all[(((df_all.team_basket .== "left") .& (df_all.event_coord_x .> 564)) .| 
        ((df_all.team_basket .== "right") .& (df_all.event_coord_x .< 564))) .& 
        df_all.three_point_shot .== true
       , :event_coord_x]











# Shot percentage,

df_sub_3pt_grid = combine(groupby(df_sub_3pt, ["event_coord_x", "event_coord_y"]), :pointmade => length => :attempt, :pointmade => sum => :score)
# Group the grid 
df_sub_3pt_grid.event_coord_x = round.(df_sub_3pt_grid.event_coord_x; sigdigits=2)
df_sub_3pt_grid.event_coord_y = round.(df_sub_3pt_grid.event_coord_y; sigdigits=2, base = 2)
# Need to problery divide up bin

df_sub_3pt_grid[:, :percentage] = df_sub_3pt_grid[:, :score]./df_sub_3pt_grid[:, :attempt]
df_sub_3pt_grid = df_sub_3pt_grid[df_sub_3pt_grid[:, :percentage] .!= 0, :]
df_sub_3pt_grid = df_sub_3pt_grid[df_sub_3pt_grid[:, :attempt] .!= 1, :]

Gadfly.plot(z = df_sub_3pt_grid.percentage,
     x=df_sub_3pt_grid.event_coord_x, y=df_sub_3pt_grid.event_coord_y, Geom.contour)

Gadfly.plot(x=df_sub_3pt_grid.event_coord_x, y=df_sub_3pt_grid.event_coord_y, color = df_sub_3pt_grid.percentage)


Gadfly.pop_theme()
# Gadfly change theme
Gadfly.Theme(RGB{N0f8}(0.996,0.263,0.396),0.9mm,0.3mm,:solid,RGB{N0f8}(0.133,0.157,0.192),nothing,1.0,RGB{N0f8}(0.133,0.157,0.192),5.0mm,RGB{N0f8}(0.341,0.341,0.341),Measures.Length{:mm,Float64}[0.5mm,0.5mm],RGB{N0f8}(0.627,0.627,0.627),0.2mm,"'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif",2.822222222222222mm,RGB{N0f8}(0.631,0.631,0.631),"'PT Sans','Helvetica Neue','Helvetica',sans-serif",3.880555555555555mm,RGB{N0f8}(0.631,0.631,0.631),"'PT Sans Caption','Helvetica Neue','Helvetica',sans-serif",2.822222222222222mm,RGB{N0f8}(0.298,0.251,0.294),"'PT Sans','Helvetica Neue','Helvetica',sans-serif",3.880555555555555mm,RGB{N0f8}(0.631,0.631,0.631),"'PT Sans','Helvetica Neue','Helvetica',sans-serif",2.822222222222222mm,RGB{N0f8}(0.631,0.631,0.631),40,-0.05mm,1.0mm,3.0mm,Gadfly.default_stroke_color,0.3mm,Gadfly.border_color,Gadfly.default_continuous_highlight_color,Gadfly.lowlight_color,0.6,Gadfly.default_middle_color,0.6mm,:left,:square,:right,nothing,Function[Compose.circle,Gadfly.square,Gadfly.diamond,Gadfly.cross,Gadfly.xcross,Gadfly.utriangle,Gadfly.dtriangle,Gadfly.star1,Gadfly.star2,Gadfly.hexagon,Gadfly.octagon],2.0mm,1000,10.0,0.5,0.2,4,Gadfly.Scale.DiscreteColorScale(Gadfly.gen_dark_colors,nothing,nothing,true),Gadfly.Scale.ContinuousColorScale(Gadfly.Scale.f,Gadfly.Scale.ContinuousScaleTransform(identity,identity,Gadfly.Scale.identity_formatter),nothing,nothing))






















#Option 2  overlay image

img_path = str_cd*"basketball_halfcourt.png"
img = load(img_path)

plt_img = Plots.plot([-30, 530], [-10, 600], reverse(img, dims = 1), yflip = false, aspect_ratio = :none, showaxis = false)
histogram2d!(df_plt_3ptatmt[:, 1], df_plt_3ptatmt[:, 2], bins = 35, showaxis = false, ticks = false)
annotate!([(-10,570,text("Three-pooint attempts", 13, :left, :top, :blue))])
savefig(plot_ref, fn) # save the fig referenced by plot_ref as fn

# OTher option

using StatsPlots
import RDatasets
iris = RDatasets.dataset("datasets", "iris")
@df iris scatter(:SepalLength, :SepalWidth, group = :Species, title = "My awesome plot", xlabel = "Length", ylabel = "Width", marker = (0.5, [:cross :hex :star7], 12), bg = RGB(0.2, 0.2, 0.2))