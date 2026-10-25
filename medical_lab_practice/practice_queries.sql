-- Activity 1: Read the specimen log
SELECT specimen_id, accession, specimen_type, acceptance
FROM specimens
ORDER BY specimen_id LIMIT 6;

-- Activity 1 solution
SELECT specimen_id, accession, specimen_type, acceptance FROM specimens ORDER BY specimen_id LIMIT 3;

-- Activity 2: Find rejected specimens
SELECT specimen_id, specimen_type, rejection_reason
FROM specimens
WHERE acceptance = 'Rejected'
ORDER BY specimen_id;

-- Activity 2 solution
SELECT specimen_id, accession FROM specimens WHERE acceptance='Accepted' AND priority='STAT' ORDER BY specimen_id LIMIT 5;

-- Activity 3: Count workload by priority
SELECT priority, COUNT(*) AS specimen_count
FROM specimens GROUP BY priority ORDER BY priority;

-- Activity 3 solution
SELECT specimen_type, COUNT(*) AS specimen_count FROM specimens GROUP BY specimen_type ORDER BY specimen_type;

-- Activity 4: Find pending results
SELECT status, COUNT(*) AS result_count,
 COUNT(result_value) AS populated_values
FROM results GROUP BY status ORDER BY status;

-- Activity 4 solution
SELECT result_id FROM results WHERE result_value IS NULL ORDER BY result_id;

-- Activity 5: Attach assay names and units
SELECT r.result_id, a.assay_name, r.result_value, a.unit
FROM results AS r JOIN assays AS a ON r.assay_id=a.assay_id
WHERE r.status='Final'
ORDER BY r.result_id LIMIT 6;

-- Activity 5 solution
SELECT r.result_id, a.assay_name, r.result_value, a.unit FROM results r JOIN assays a ON r.assay_id=a.assay_id WHERE r.status='Final' AND a.assay_name='Hemoglobin' ORDER BY r.result_id LIMIT 5;

-- Activity 6: Calculate turnaround minutes
SELECT r.result_id, s.priority,
 ROUND((julianday(r.released_at)-julianday(s.received_at))*1440,0) AS turnaround_min
FROM results r JOIN specimens s ON r.specimen_id=s.specimen_id
WHERE r.status='Final'
ORDER BY turnaround_min DESC, r.result_id LIMIT 5;

-- Activity 6 solution
SELECT r.result_id, ROUND((julianday(r.released_at)-julianday(s.received_at))*1440,0) AS turnaround_min FROM results r JOIN specimens s ON r.specimen_id=s.specimen_id WHERE r.status='Final' AND s.priority='STAT' ORDER BY turnaround_min, r.result_id LIMIT 5;

-- Activity 7: Summarize turnaround by priority
SELECT s.priority, COUNT(*) AS final_results,
 ROUND(AVG((julianday(r.released_at)-julianday(s.received_at))*1440),1) AS avg_min
FROM results r JOIN specimens s ON r.specimen_id=s.specimen_id
WHERE r.status='Final' GROUP BY s.priority ORDER BY s.priority;

-- Activity 7 solution
SELECT s.specimen_type, COUNT(*) AS final_results, ROUND(AVG((julianday(r.released_at)-julianday(s.received_at))*1440),1) AS avg_min FROM results r JOIN specimens s ON r.specimen_id=s.specimen_id WHERE r.status='Final' GROUP BY s.specimen_type ORDER BY s.specimen_type;

-- Activity 8: Keep assays with zero results
SELECT a.assay_name, COUNT(r.result_id) AS result_count
FROM assays a LEFT JOIN results r ON a.assay_id=r.assay_id
GROUP BY a.assay_id,a.assay_name ORDER BY a.assay_id;

-- Activity 8 solution
SELECT a.assay_name, COUNT(r.result_id) AS result_count FROM assays a LEFT JOIN results r ON a.assay_id=r.assay_id GROUP BY a.assay_id,a.assay_name HAVING COUNT(r.result_id)=0 ORDER BY a.assay_id;

-- Activity 9: Explore a QC trend
SELECT run_date, measured_value,
 ROUND((measured_value-training_target)/training_sd,1) AS deviation_sd
FROM qc_runs WHERE assay_id=1 ORDER BY run_date;

-- Activity 9 solution
SELECT run_date, measured_value, ROUND((measured_value-training_target)/training_sd,1) AS deviation_sd FROM qc_runs WHERE assay_id=3 ORDER BY deviation_sd DESC,run_date;

-- Final challenge
SELECT specimen_type, COUNT(*) AS received,
 SUM(CASE WHEN acceptance='Rejected' THEN 1 ELSE 0 END) AS rejected,
 ROUND(100.0*SUM(CASE WHEN acceptance='Rejected' THEN 1 ELSE 0 END)/COUNT(*),1) AS rejection_pct
FROM specimens GROUP BY specimen_type ORDER BY specimen_type;