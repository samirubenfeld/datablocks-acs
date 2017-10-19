connection: "bq-looker-datablocks"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

include: "bq.explore"
include: "bq.*.view.lkml"



# explore: bq_tract_zcta_map {}


map_layer: block_group {
  format: "vector_tile_region"
  url: "https://a.tiles.mapbox.com/v4/dwmintz.4mqiv49l/{z}/{x}/{y}.mvt?access_token=pk.eyJ1IjoiZHdtaW50eiIsImEiOiJjajFoemQxejEwMHVtMzJwamw4OXprZWg0In0.qM9sl1WAxbEUMVukVGMazQ"
  feature_key: "us_block_groups_simple-c0qtbp"
  extents_json_url: "https://cdn.rawgit.com/dwmintz/census_extents2/59fa2cd8/bg_extents.json"
#   min_zoom_level: 9
  max_zoom_level: 12
  property_key: "GEOID"
}

map_layer: tract {
  format: "vector_tile_region"
  url: "https://a.tiles.mapbox.com/v4/dwmintz.3zfb3asw/{z}/{x}/{y}.mvt?access_token=pk.eyJ1IjoiZHdtaW50eiIsImEiOiJjajFoemQxejEwMHVtMzJwamw4OXprZWg0In0.qM9sl1WAxbEUMVukVGMazQ"
  feature_key: "us_tracts-6w08eq"
  extents_json_url: "https://cdn.rawgit.com/dwmintz/census_extents2/396e32db/tract_extents.json"
  min_zoom_level: 6
  max_zoom_level: 12
  property_key: "GEOID"
}


explore: gsod {
  from: bq_gsod
  join: zipcode_station {
    from: bq_zipcode_station
    view_label: "Geography"
    type: left_outer
    relationship: many_to_one
    sql_on: ${gsod.station_id} = ${zipcode_station.nearest_station_id}
      and ${gsod.year} = ${zipcode_station.year};;
  }
  join: stations {
    from: bq_stations
    type: left_outer
    relationship: many_to_one
    sql_on: ${zipcode_station.nearest_station_id} = ${stations.station_id} ;;
  }
  join: zipcode_county{
    from: bq_zipcode_county
    view_label: "Geography"
    type: left_outer
    relationship: many_to_one
    sql_on: ${zipcode_station.zipcode} = ${zipcode_county.zipcode}  ;;
  }
  join: zipcode_facts {
    from: bq_zipcode_facts
    view_label: "Geography"
    type: left_outer
    relationship: one_to_many
    sql_on: ${zipcode_county.zipcode} = ${zipcode_facts.zipcode} ;;
  }
}

explore: zipcode_county {
  from: bq_zipcode_county
  join: zipcode_facts {
    from: bq_zipcode_facts
    type: left_outer
    sql_on: ${zipcode_county.zipcode} = ${zipcode_facts.zipcode} ;;
    relationship: one_to_many
  }
  join: zipcode_station {
    from: bq_zipcode_station
    type: left_outer
    relationship: many_to_one
    sql_on: ${zipcode_county.zipcode} = ${zipcode_station.zipcode} ;;
  }
  join: stations {
    from: bq_stations
    type: left_outer
    relationship: one_to_one
    sql_on: ${zipcode_station.nearest_station_id} = ${stations.station_id} ;;
  }
}
# explore: fast_facts {
#   from: bq_logrecno_bg_map

#   join: block_group_facts {
#     from: bq_block_group_facts
#     view_label: "Fast Facts"
#     sql_on: ${fast_facts.block_group} = ${block_group_facts.logrecno_bg_map_block_group};;
#     relationship: one_to_one
#   }

#   join: tract_zcta_map {
#     from: bq_tract_zcta_map
#     sql_on: ${fast_facts.geoid11} = ${tract_zcta_map.geoid11};;
#     relationship: many_to_one
#   }

#   join: zcta_distances {
#     from: bq_zcta_distances
#     sql_on: ${tract_zcta_map.ZCTA5} = ${zcta_distances.zip2} ;;
#     relationship: one_to_one
#     required_joins: [tract_zcta_map]
#   }
# }
