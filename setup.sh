oc new-project knativedemo
oc adm policy add-scc-to-user privileged -z default 
oc adm policy add-scc-to-user anyuid -z default
