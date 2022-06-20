CREATE USER 'n8n_service'@'%' IDENTIFIED BY 'n8n_workflow';
GRANT ALL PRIVILEGES ON n8n_workflow. * TO 'n8n_service'@'%';
CREATE USER 'n8n_webhook'@'%' IDENTIFIED BY 'n8n_workflow';
GRANT ALL PRIVILEGES ON n8n_workflow. * TO 'n8n_webhook'@'%';
CREATE USER 'n8n_worker'@'%' IDENTIFIED BY 'n8n_workflow';
GRANT ALL PRIVILEGES ON n8n_workflow. * TO 'n8n_worker'@'%';