MEDICAL LAB SQL PRACTICE
Entirely synthetic. No patient records.
Open hands_on_medical_lab.html in a browser. Use its embedded setup script in SQLite Fiddle, or open lab_training.sqlite in DB Browser.
Date range: October 1–10, 2026. Timestamps are naive local training times.
Counts: {"assays": 7, "specimens": 60, "results": 110, "qc_runs": 20}
CSV blanks represent NULL. The SQLite file preserves types and relationships. Reset script deletes and recreates the four training tables.
Data dictionary:
{
  "assays": [
    "assay_id: integer primary key (unique test identifier)",
    "assay_name: test name",
    "department: Chemistry or Hematology",
    "specimen_type: compatible sample type",
    "unit: unit for results and QC measurements"
  ],
  "specimens": [
    "specimen_id: integer primary key",
    "accession: synthetic unique text identifier",
    "received_at: timestamp YYYY-MM-DD HH:MM:SS",
    "source_area: invented Emergency, Ward or Outpatient",
    "priority: STAT or Routine",
    "specimen_type: Plasma, Whole blood or Serum",
    "acceptance: Accepted or Rejected",
    "rejection_reason: reason text, NULL if accepted"
  ],
  "results": [
    "result_id: integer primary key",
    "specimen_id: foreign key to specimens",
    "assay_id: foreign key to assays",
    "result_value: numeric measurement, NULL if pending; unit comes from assays",
    "released_at: timestamp, NULL if pending",
    "status: Final or Pending"
  ],
  "qc_runs": [
    "qc_id: integer primary key",
    "run_date: YYYY-MM-DD text",
    "assay_id: foreign key to assays",
    "control_lot: fictional lot identifier",
    "control_level: Level 1 in this exercise",
    "measured_value: numeric measurement in the assay unit",
    "training_target: invented control target in the assay unit",
    "training_sd: invented positive standard deviation in the assay unit"
  ]
}
QC targets/SDs are invented teaching constants, not validated clinical limits. Source area and specimen type are deliberately patterned.
