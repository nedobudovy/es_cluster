#!/bin/bash

echo "🔍 Checking Kibana Status..."
echo "================================"

# Check if VMs are running
echo "📊 VM Status:"
vagrant status

echo ""
echo "🌐 Network Connectivity:"
# Check if Kibana VM is reachable
ping -c 2 192.168.56.99 > /dev/null 2>&1 && echo "✅ Kibana VM (192.168.56.99) is reachable" || echo "❌ Kibana VM (192.168.56.99) is not reachable"

# Check if Nginx VM is reachable
ping -c 2 192.168.56.98 > /dev/null 2>&1 && echo "✅ Nginx VM (192.168.56.98) is reachable" || echo "❌ Nginx VM (192.168.56.98) is not reachable"

echo ""
echo "🔌 Port Connectivity:"
# Check Kibana direct access
nc -z -w5 192.168.56.99 5601 && echo "✅ Kibana port 5601 is open" || echo "❌ Kibana port 5601 is closed"

# Check Nginx ports
nc -z -w5 192.168.56.98 80 && echo "✅ Nginx HTTP port 80 is open" || echo "❌ Nginx HTTP port 80 is closed"
nc -z -w5 192.168.56.98 443 && echo "✅ Nginx HTTPS port 443 is open" || echo "❌ Nginx HTTPS port 443 is closed"

# Check forwarded ports on localhost
nc -z -w5 localhost 5601 && echo "✅ Kibana forwarded port 5601 is accessible" || echo "❌ Kibana forwarded port 5601 is not accessible"
nc -z -w5 localhost 8443 && echo "✅ Nginx forwarded port 8443 is accessible" || echo "❌ Nginx forwarded port 8443 is not accessible"

echo ""
echo "🌍 HTTP/HTTPS Checks:"
# Check Kibana direct HTTPS
echo "Checking Kibana direct access..."
curl -k -s -o /dev/null -w "%{http_code}" https://192.168.56.99:5601 | grep -q "200\|302\|401" && echo "✅ Kibana HTTPS responds" || echo "❌ Kibana HTTPS not responding"

# Check Nginx HTTP (should redirect)
echo "Checking Nginx HTTP (should redirect)..."
curl -s -o /dev/null -w "%{http_code}" http://192.168.56.98 | grep -q "301\|302" && echo "✅ Nginx HTTP redirects to HTTPS" || echo "❌ Nginx HTTP not redirecting"

# Check Nginx HTTPS
echo "Checking Nginx HTTPS..."
curl -k -s -o /dev/null -w "%{http_code}" https://192.168.56.98 | grep -q "200\|302\|401" && echo "✅ Nginx HTTPS responds" || echo "❌ Nginx HTTPS not responding"

# Check Nginx health endpoint
echo "Checking Nginx health endpoint..."
curl -k -s https://192.168.56.98/nginx-health | grep -q "healthy" && echo "✅ Nginx health check passes" || echo "❌ Nginx health check fails"

echo ""
echo "🖥️  Access URLs:"
echo "Direct Kibana:    https://192.168.56.99:5601"
echo "Via Nginx:        https://192.168.56.98"
echo "Local (Kibana):   https://localhost:5601"
echo "Local (Nginx):    https://localhost:8443" 