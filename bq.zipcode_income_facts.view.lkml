include: "bq.explore.lkml"

view: bq_zipcode_income_facts {
  derived_table: {
    explore_source: fast_facts {
      column: ZCTA5 { field: tract_zcta_map.ZCTA5 }
      column: income_household { field: block_group_facts.avg_income_house }
      column: total_population { field: block_group_facts.total_population }
    }
  }
  dimension: ZCTA5 {}
  dimension: income_household {
    hidden: yes
  }
  }
