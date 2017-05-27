(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��)Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq�p������}���Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�	��xM��)����_���J�e���?�x�:�\�(IЕ�����{�+��[G���'�j���_����g�8�_�˟�i�������t�eؙ.�t���)�����k��GcAQ�(��'�������g�^����c�?��.��.�y��S6�6J�4JS�C6�,BQ>B:>���`��x�(��M�Yc���Q��O�"^��8�>��x�9�K)��p�u'6d�&�B�z�lC��E�)M��(�2�I}a,0���F)�[e�ւ6U�	�e���i�ϯ}�`!���x�	Z��Աc���#��sݧ(��h��:���OYz8�l%�n���Ri&������Ł��"�-T?�%�^|��}��+��K��ww�o�_���M�����^n�Q�Oe������]����u�G���G	{��	��������Eݐ%�/���e�i�<p�!�e���,%>���-3�x�\���2@���d>��4M 3.T�,�x�LMk�y�DC)nЁ�sJ[ä���nD&�!N;�q;E`�F�{��3{�Μ��+�9x��n�\�sv?>�;� =.TM(���Q��F�N�$"�J��Q�x$r�&���}Zn	bG�s&
o��N< :��\�8�E�୍=w��y�!�Eޔk��������VA�7Ks!?�� �|<4��Z*7V8���ϴ	B�D���MA� ����J��7�v}1ߍ$2%�F�4���5Vl�Z�:����6��Y�J.�\���+-5���Q��Δn�Z�lt�<����\��\�"Of�w�f��y4�P?�����saI
&oE�#]��EY�.2&����N�yX12[�FѦI����(�7͕��d(D�$�8�e�G �C'r����"�.a�E��,��~����a�];�Cn9I[RMM/F]}�d	�,�9�x�,z�4����������gf9�%��M�7��{��+�/$�G�Om�W�}��ZdW�_^�qV�����#ü�ީ��.Yo	$��-����9ǉP�1�%�
��Q�N����٩pP��*�*Hv�Vp?�+3�>M�� ��,,LCѕ�&�,�`w�8b�N��(��K���s԰�D�/['RS�w�йY��f�Ǧ�{E��bn5o;�p��;P �{�-C���O�e虻l�S�r!<QuhM���ãr����)gF���Y ���@��O��8^���X{x�gB��Z���C]��;����6%�|�H�9��A�A�9lQ��Qt�f��LH��5>�8�hQ�y��k�_
r���M��X����sS��gr]K���m3�>�P�0Y����O�K�ߵ������O��������g������E������������s�_��o�	���	G*�/�$�ό���RP��T�?�>�I���D1�(�-�NPLf��u���@X$�q��\֡0�\�P��Y������e����G�?AU�_� ��o���~�Ѥ���#��u�u<K�s�G ��e�?�����-ض�`FL�9i��e�l)�z�"��Ɨs�3ܠ��Ȃ�`�͍9�Z�+���u�`5J�`�Y��4��ދ_����S�������������/��_��W��U������S�)� �?J������+o�����o�Px$t�0�7[� -x�������]>tl�0�ެ���31��B���d�{*��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x��	����NV�;�g���5�H��q9#�����@~���-�A�%�S�q�s ��l(bK Ӑ���s'������m�2	\X�7h�y��磅iϞ�P���I`*����;����C���b��v�in��:K{��,�;�!/7;��
�(!�D��|$s�"yY��	���@N�b�Ak����S���������2�!�������KA��W����������k�����-H���2p��_��q1��*�/�W�_������C�J=��HA���2p	�{�M:x�������Юoh�a8�zn��(°J",�8, �Ϣ4K��]E��~(C����!t�T�%���?�	�"�Z�T��csbkL�6��s�U�����Г��b�J }'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߻�x�ǩ�~���?J��9x���'���w��P�����B�߾�L)\.����_
�+���/_V�˟�q���H����b��(�T�K���������t��S>e��4B�?��9�m�.cS,���x.����a�G#�n�8K0A��6˰>Z-��2�������>��t����0Qx1�v�z���`�]��c��F����_\�Yh����8��u��RTO�È�<j̄�]��kF�A��!�Sn;�"l�z&⚠:����l�Z�y7>r�����AU�_)��?�$���q�ge�}>>i�?Ⱦ4Z�B�(C���(A>��&����R�Z�W���������]���X��a���ǳ�>�Y@���g�ݏ��{P����]P�z�F��=tw��ρnX�΁���~�9�Ѓ��6��2q�p��N�}1/�.���G��&1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8��n�u_;ms.���k ��ݚ�r.k)ZV�y:E��ڔ�9��t��nw�cC��B�w{�C ����䶷�<����à�bM p"�r65�y{WW\����Vd���Fg9�,3�V�֟��A��߃ j�;%6�NГr�&{+~f��ni���p�5��!��x����/m�����_
~���+��o�����Vn�o�2�����l�'������m�?���?�m�a��o��N2;M�p�g�?���qo(�g���@y�@wA޺d�d����5`�5M|��?�O΃���ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ��y��!�~��܇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/q����d�W
~��|�Q��)	�1����ʐ�{�����Y����j��Z�������7��w�s���aX�����r�_n�]���PU�g)��������\��-�(���O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0�:�B������/$]������ �eJ���-sjư���S�m�m+[,�Fi�5yq��1��t�V�֕�FwGѽdMq=�o{;�cF��sh}�
��A~
ӻ�N���r���)�2�Q_��,6��y����bw�����8��������������/�V��U
�~�Z�k�/�/��t;u��+T��6r��j������>�Ӆ��tl'��W��u�P7q�^#�ȕ�H&��3�r;M�e�/��Jj���8]�oxp��*�7�_��k�:��OOL�t�}��_4B_��uJ+nd/���lR�rk=��v�vU�\W+��¯�z�'�}_�8W4�����'�ծ��i�����$��v坺`/6������KNu��֧����ڞ.��fiGŨp훻ʠ����p;r���}eX��hluuA�E��!��:7�o�*]���!ק�K�}���F�+|;��������>w�z��8N����Q��E�g_nl��ߓ�o���7��d�y�,�3�^����o���:b��"{�a�%o�� ��w[/��������i]��Wv7�~Z���<���ϫ��g￟��c��_m�\T{X����q:�.�o�~��q���8��8K]8��'�PY?�n��v��&>ф�D����8���S�n�>*���~~ˇ#������NY��c������	d��
�8��!�"v�7�h�<.��#��:����M��3B�+�Ʒ�r��
��$����N�t��ϖ�u�p��>��q[L������6�u����r9<.��r�˘�b���u�K��tݺ�t�ֽoJ�=]�n�֞v��5!&��4�o4B�@�D?)����A	$D�`����ж�z��휝����&�t��y���������y��Kz��t�<��|��J�4D�
�g�d��ERx6��v��F��L,u)���ønm��1�ѓ�5Y^�ޗ�t�[]�o���4+�cѥ� l�^ ��k@�>��g6�	9���	�B>�h���*K�����������pM4'�F��~� 4��23i�aX�����h�mf�f��xdɈ���麩k�v�X%�;��8�^=<�ߡ$A��Mf�#�m![H�)Z��O�KP/U�*ۑ���fqθ	G�胉�f��8���)��GBdV���q]�����7k��>���b�4d�:*�·*�%�C�n���h�,GS䃍��0�}��� mN�����L6��pz48���)�� ��w��#?��i>���:��b'�/*;T�Ӫ,��{0�����Tk5�.s�렖N�B�A7��SIG�x��~�����~�-�3z:��Ƌ��oFB�����]ѯ}��ߕ��^�
�qjM1�0��]� �,��>��k�㒻��e��1�3�t=l��3����E]䢹@٢F)�<(��v�f� �r�	�Z]�����L^�����smo_��먒�lAU8n�0��~�\��{�=8����'i�L~�I��2�1p^�c�N�qPo�4cosb�1��U~��k�\:>u�os�X����K���kQQ�or�v!�۵�9�eWg��ɩ|E���c�����G��+�G��|�M6���[u���Ǎ���~�A�����?�~���C��vb�����~��W;��T���H��wy\� �� `�m/�������<`��m_���G�WA<��<��=<� '�:{{��;�����n�f�{������.=���A�P�
�V����	�¡:���`7.�x�Ə΁���g�A�>=qn���O@jrƦ����=��0G`$�Sܼ^���9�EE.Ag�]���l��0&���su�0�O!|0�x緙��(,��]>Pm9"���aw,Qv���f���vs�BD��N��f���)˽\�~�J�tA=L���0�b�z����d3����3�mN6t��$�g���9
SJt��0Q��i:KG;��zL���Dx�,�g��fQe��A_�46SE�E&�R�S�g�=J�7JyQ��a9Um	1!����`!�m�TU�X6�^/��8���K!
�ri?r��)�	k3am&�*LX��v;d ,�/�6�����]��[j�p��=5WB֭j��	��E�5%q�A@y��+�d��v�l��z\��Z���M�	��<�
m��h�H()f�d���	�8��̰ä�t93-8�v$�b-���u����X����&L�~`���X%�ZVj�X+��ҟ�E�,VӼx-�%�(i��i�yϰ�U��D�No'�B.H����!�c"�n���+K���e��3ʲ��l�R ˥�o�S)~w���i&?�|�G�E?õ��|�C�Y�կ��a��j�M*X�S����|*WVU�ܦ�,8#�y�(Q:\HUEӴ��㙖��S�=�3�K�%�z��GӾ!Ih]>F�
��i�:������MZ�SY�j1�݉*h?��U*���\�)�{�j��%�>WU\xo�%�HY�������WP�(����[.�����!A�M�I�3Ԛ����J��[xa�a5�+Ѣ���k'��r��7��FbRM 9�>����dM�"�Ue$�&�Jg���)��٥�6a�Ї�-V��i��
0�d�^�_k,!�ل��!��- ��lHꎏH���ʵ	)��ꞡ�&E�A	�'Y�4����i�l��f�l��l�p#�9QpMA��yU�>�[�ڀ֠S��kWl����~��2y��� 9t�ۧ�Cg��_9]U�g+��j�.p]�ms�b�;m�F�p���jj�������研,ոtt#��8^i�4:�q'���Ҽ�Vk�WZ���zB?÷���(<��'5Y�-'��lM�6䡛��k`�ᇟC�>��úM��9g�3kWA`�{��%s�4(�yV�U̖C�@����Z�c�<��,��i��S\V��ypW�/F>sz2+f�z�@t�'ʪ��L���Y ��f$}�Q��Y����GnE^�^��Z����[��R`���R���C�h����� �"	���t�B��[��g+;��p�Z�H����Ƣ���h�0�%k8z�`�K{�8�NZLOc�YS��{��A$�D��)��M��/�^��F,�J�.�▖h��D+�DCH�C�^��B"(t���-��G�s���I�+���a�B�S�C#{0p ���-&��|���q�����xH7��51"�%j���A�!�no<�`UW��b4SˑL#�a0җ����}B�.P����������a҂]�+[�k�a��9��!�	�}��-Q�")D�#��u�LS &�Co9���>.մb/��}��i�m�q�Ǻv�����t��)�������i�����ݡ�:��z贕a��xX�=,��[�O���޿���,�I��D�VD2S��Q
W�H���\���1/;���@����3�<X��u��E��$&���
��"�͚����x[��3��0jSI`bJى�!2(��d
G�vJ�Ԗ+�0���������]&�xY�p#�QnO���0<�}Q8]JI���t0do,6�!
��<��.�	�[j���g��;(EyrHԕ(t��+}t���<@�^�,���G��U����I^�È�2	��g�~����%��;��&&�$ι �ɒ�V��r�n���]�z��]�ye�6�8�ߌ�Pޏ{6ⷒS�>�S6�c���J!��l��f�.Ķ�(�����i���Q�h���tÔ��8��W**�i������>�%~���%A�oAlB�Ne����;��J�r�\�h��<NB'�+,7�"��]�>��7�Z/��i�~�[/=������Ky��C����fW���|7;ͦ�Տ�����w���ra6��2$��p<��~� �}��?���O?��o�����j��Oϟ��O��w��n]�����_�\��m^M'�U�����_�ɏ=���亂?���k�����7>�$�:^��?RП���/8�7g�����N��iS;m��M����W���W\; m�mj�M������f�l�j�����z���Uh�~p�0B�\���5�E��I�c �[������>�~�������kSԄ!�g`�u6����jJ�y�q�������<k�r�,�뵩i6�<-{Όm������i���8l�sf�0��S`.�̜��;DhmU��K=F2�q�K�ZW����Nv���޷�xe��  