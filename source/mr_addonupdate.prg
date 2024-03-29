*!* mr_addonupdate

Lparameters paid, pforce

Local winhttp As 'winhttp' Of 'winhttp.vcx'
Local hajson, haresponse, hfjson, hfresponse, nselect, result, url

m.nselect = Select()

If Not Used('addons_up')

   Use 'mr_addons' In 0 Again Shared Order Tag 'aid' Descending Alias 'addons_up'

Endif

If Seek(m.paid, 'addons_up', 'aid') = .F. Then

   Append Blank In 'addons_up'

   Replace addons_up.aid With m.paid In 'addons_up'

Endif

If addons_up.haresponse = 0 Or m.pforce

   _logwrite('ADDON UPDATE START', m.paid)

   m.winhttp = Newobject('winhttp', 'winhttp.vcx')

   *m.winhttp.setproxy(2, 'localhost:8888')

   m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

   m.winhttp.gzip = .T.

   m.winhttp.option_enableredirects = .T.

   m.url = 'https://addons-ecs.forgesvc.net/api/v2/addon/' + Transform(addons_up.aid)

   m.winhttp.Open('GET', m.url, .T.)

   m.result = m.winhttp.Send()

   Do While m.winhttp.waitforresponse(0) = 0

      DoEvents

      _apisleep(10)

   Enddo

   m.haresponse = m.winhttp.responsestatus

   *!* IF NO INTERNET, SKIP

   If m.haresponse # 0 Then

      *!* ONLY IF SUCESS UPDATE DATA

      If m.haresponse = 200

         m.hajson = Chrtran(m.winhttp.getresponse(), 0h09200a0d, '')

         Replace addons_up.hajson With m.hajson In 'addons_up'

         mr_addonparse(addons_up.aid, m.hajson)

      Endif

      *!* UPDATE GET FIELDS

      Replace addons_up.haresponse With m.haresponse, addons_up.hadatetime With Datetime() In 'addons_up'

   Endif

   _logwrite('ADDON UPDATE END', m.paid)

Endif


If addons_up.haresponse = 200 And addons_up.agameid = 432

   If addons_up.hfresponse = 0 Or m.pforce

      _logwrite('FILES UPDATE START', m.paid)

      m.winhttp = Newobject('winhttp', 'winhttp.vcx')

      *m.winhttp.setproxy(2, 'localhost:8888')

      m.winhttp.SetTimeouts(60000, 60000, 30000, 60000)

      m.winhttp.gzip = .T.

      m.winhttp.option_enableredirects = .T.

      m.url = 'https://addons-ecs.forgesvc.net/api/v2/addon/' + Transform(addons_up.aid) + '/files'

      m.winhttp.Open('GET', m.url, .T.)

      m.result = m.winhttp.Send()

      Do While m.winhttp.waitforresponse(0) = 0

         DoEvents

         _apisleep(10)

      Enddo

      m.hfresponse = m.winhttp.responsestatus

      *!* IF NO INTERNET, SKIP

      If m.hfresponse # 0 Then

         *!* ONLY IF SUCESS UPDATE DATA

         If m.hfresponse = 200

            m.hfjson = Chrtran(m.winhttp.getresponse(), 0h09200a0d, '')

            mr_fileparse(addons_up.aid, m.hfjson)

         Endif

         *!* UPDATE GET FIELDS

         Replace addons_up.hfresponse With m.hfresponse, addons_up.hfdatetime With Datetime() In 'addons_up'

      Endif

      _logwrite('FILES UPDATE END', m.paid)

   Endif

Endif

Use In 'addons_up'

Select(m.nselect)




