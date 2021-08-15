# Duncan Robinson's career as Michigan Wolverine

This is a part of sports analytics application series: Exploratory Data Analysis (EDA) of Duncan Robinson's playing career for the University of Michigan Wolverine Men's Basketball team. Specifically, the analysis observes three-point attempts and scores, observing 2015-16, 2016-17, and 2017-18 seasons. 

*Chart: Three-point shot attempts - all NCAA plays from 2015-16, 2016-17, and 2017-18 seasons*
<p align="center">
  <img src="https://github.com/justinjoliver/umich-robinson-plays/blob/main/eda/plt_3pt_scores_all_fullcourt_ncaa.png" alt="Your image title" width="600"/>
</p>
     
Michigan Wolverine during the period heavily depended its scoring on three-point field goals; the concerted efforts turned *verschlimmbessern* in challenged games, even during the successful seasons. Among their shooters, [Duncan Robinson](https://mgoblue.com/sports/mens-basketball/roster/duncan-robinson/15226) became one of the most efficient three-point shooter in NBA as an undrafted rookie with [Miami Heat](https://www.nba.com/heat/news/heat-resigns-duncan-robinson). The exercises below evaluate his three-point shooting performance at Michigan - an evidence translated into his future success.

## NCAA basketball data
NCAA Basketball's play-by-play data during Duncan Robinson's career at University of Michigan is pulled from NCAA's historical play-by-play statistics from Google's [BigQuery](https://console.cloud.google.com/marketplace/details/ncaa-bb-public/ncaa-basketball?pli=1). All reference statistics used here comes from the dataset. The data contains location coordinate of the basketball court, which allows us to identify where each play happened (i.e. location of the shots attempted and made/missed). For *Theatrum Chemicum*, all shot locations are adjusted so that data are symmetrically represented in half court as shown below.

*Chart: Three-point shot attempts - all NCAA plays from 2015-16, 2016-17, and 2017-18 seasons - half-court adjusted*
<p align="center">
  <img src="https://github.com/justinjoliver/umich-robinson-plays/blob/main/eda/shot_attempts.png" alt="Your image title" width="600"/>
</p>

## Statistics - Three-point field goals: 2015 to 2018 seasons

#### Duncan Robinson - University of Michigan Wolverine

| Games | Three-point scores | Three-point attempts | Percent |
| --- | :---: | :---: | :---: |
| Conference - regular season | 193 | 515 | 37.4% |
| Conference - tournament | 18 | 53 | 34.0% |
| March Madness | 18 | 55 | 32.7% |

#### University of Michigan Wolverine

| Games | Three-point scores | Three-point attempts | Percent |
| --- | :---: | :---: | :---: |
| Conference - regular season | 848 | 2,931 | 28.9% |
| Conference - tournament | 88 | 334 | 26.3% |
| March Madness | 90 | 352 | 25.6% |

#### NCAA

| Games | Three-point scores | Three-point attempts | Percent |
| --- | :---: | :---: | :---: |
| Conference - regular season | 85,984 | 322,005 | 26.7% |
| Conference - tournament | 12,084 | 45,393 | 26.6% |
| March Madness | 4,911 | 18,623 | 26.4% |

## Shot locations and comparisons: 2015 to 2018 seasons

### Duncan Robinson
Three-point attempt             |  Three-point made
:-------------------------:|:-------------------------:
![](https://github.com/justinjoliver/umich-robinson-plays/blob/main/eda/plt_3pt_attempt_robinson.png)  |  ![](https://github.com/justinjoliver/umich-robinson-plays/blob/main/eda/plt_3pt_scores_robinson.png)

### NCAA
Three-point attempt             |  Three-point made
:-------------------------:|:-------------------------:
![](https://github.com/justinjoliver/umich-robinson-plays/blob/main/eda/plt_3pt_attempt_all_ncaa.png)  |  ![](https://github.com/justinjoliver/umich-robinson-plays/blob/main/eda/plt_3pt_scores_all_ncaa.png)
