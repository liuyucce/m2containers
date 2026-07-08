FROM rabbitmq:4.3.0-management-alpine

RUN rabbitmq-plugins enable --offline rabbitmq_shovel rabbitmq_shovel_management rabbitmq_prometheus

COPY rabbitmq.conf /etc/rabbitmq/conf.d/20-custom.conf

EXPOSE 4369 5671 5672 15671 15672 15692 25672
