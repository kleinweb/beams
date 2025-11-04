list-recovery-points vault fields="RecoveryPointArn,CreationDate":
    aws backup list-recovery-points-by-backup-vault \
        --backup-vault-name {{ vault }} \
        --query 'RecoveryPoints[].[{{ fields }}]' \
        --output table

get-recovery-points vault filter="":
    aws backup list-recovery-points-by-backup-vault \
        --backup-vault-name {{ vault }} \
        --query 'RecoveryPoints[{{ filter }}].RecoveryPointArn' \
        --output text

[confirm]
delete-recovery-points vault filter="":
    for arn in `just aws::backups::get-recovery-points {{ vault }} {{ filter }}`; do \
        echo "Deleting: $arn"; \
        aws backup delete-recovery-point \
            --backup-vault-name {{ vault }} \
            --recovery-point-arn "$arn"; \
    done
