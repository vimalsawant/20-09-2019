FROM sres.web.boeing.com:5000/library/nginx:1.13.6

# support running as arbitrary user which belongs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# change default.conf and expose port
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /etc/ssl
COPY nginx/onepdl-frontend.key /etc/ssl/onepdl-frontend.key
COPY nginx/onepdl-frontend.pem /etc/ssl/onepdl-frontend.pem
EXPOSE 8080 443

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

COPY dist/onepdl /usr/share/nginx/html

RUN addgroup nginx root
USER nginx