include: "bq.explore.lkml"

view: bq_zipcode_income_facts {
  derived_table: {
    explore_source: fast_facts {
      column: ZCTA5 { field: tract_zcta_map.ZCTA5 }
#       column: income_household { field: block_group_facts.avg_income_house }
      column: avg_income_house { field: block_group_facts.avg_income_house }
      column: aggregate_income{ field: block_group_facts.aggregate_income}
      column: housing_units {field:block_group_facts.housing_units}
      column: total_population { field: block_group_facts.total_population }
    }
  }
  dimension: ZCTA5 {}

  dimension: total_population {

  }

#   dimension: income_household {
#     hidden: no
#     value_format: "$#,##0.00"
#   }


# Income Measure
measure: aggregate_income {
  hidden: yes
  type: sum
  group_label: "Households"
  sql: ${TABLE}.aggregate_income ;;
}

  measure: housing_units {
    type: sum
    group_label: "Households"
    sql: ${TABLE}.housing_units ;;
  }


measure: avg_income_house {
  type: number
  group_label: "Households"
  label: "Average Income per Household"
  sql: ${aggregate_income}/NULLIF(${housing_units}, 0) ;;
  value_format_name: usd_0
}
}
