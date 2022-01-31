Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EEC4A4127
	for <lists+kvm-ppc@lfdr.de>; Mon, 31 Jan 2022 12:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348671AbiAaLCX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 31 Jan 2022 06:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358761AbiAaLBT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 31 Jan 2022 06:01:19 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84542C0613A3
        for <kvm-ppc@vger.kernel.org>; Mon, 31 Jan 2022 03:00:08 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id e8so10991863ilm.13
        for <kvm-ppc@vger.kernel.org>; Mon, 31 Jan 2022 03:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=FANIUiWvB3mdY3zLX2DODg2pUIL5eGT5wlydl6jYk40=;
        b=Ozk//2swZ4n+9EW8l8AJE1MTLlpoaCXK3xzfpPFLIseBsOa2jBlUIXPufJKZWOZJb1
         LZYSIA+qJrwb7cNfMphudC5bBa0wGV8S3gL6kVVbqGkOdt0B4XP1yUbpKkdrSgOk4SCw
         v1C0S0LKRkjJnU7f896SEI1wlEalwFx9Rgq5irerJa96uqZolG/hVsfTboEhp5Wo262X
         Bw5DjIfp6f3BMZuUcN/21CQmX+e0cBVKV6O17yhSY33CkiO9iN1/rQChZ0P/9curfp6q
         4Ae69srjWBiOD2IQLksGh38ZmWapdFwCTJxNZE6Fdwc1T0xvGWym84r63rPu354BmJN+
         Mxew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=FANIUiWvB3mdY3zLX2DODg2pUIL5eGT5wlydl6jYk40=;
        b=sFnPkbFno1k+5HPuKpznNq5eaTpzyRuA2a+a7U9nZGfiElSHlBMiHQiTUC9MQsZsrC
         6q+dXvynxO2Eco7oZb3ItZpvLby9ek5WZK1aip/eNqiP5GzATuCht2sTd9TMh5i2UN6h
         XUxQcF1KamGMcrmBx0Z6H0qX+0cvww9GtUoJPQ8OAZV2nlI1RLwMD0u5o6XbajV8Kc13
         gppva8yOzG/cMp71C9RPV8eCwVztkgvbtw5T2XihPYgQtWBc8yQX2ETxq+hxTeHCgwqJ
         2p7dMr0SNkPVYOtLZRbL3hIgQHD/GyhUdCuoEC3iQokltIrspi7Y/eXMNyrIGQnZukrv
         2hnA==
X-Gm-Message-State: AOAM5334XVfPpNRyLaebCo4RqXqmdvt+Jg1hUXoPBlm6WKrIIEDOc1gL
        rGr4axdyo4iywF3dR4RK/mLHWC0cjtL6SidE+1U=
X-Google-Smtp-Source: ABdhPJwTER/p0YcvOwwJid91RzPvkEw8DmHtUlVRny5nV0kksgWcR6ScIqwhpLtpjii0MFHZVgmhnLw6wJn43CXNw30=
X-Received: by 2002:a92:ca4f:: with SMTP id q15mr10723189ilo.181.1643626807913;
 Mon, 31 Jan 2022 03:00:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: daniellakyle60@gmail.com
Sender: drdanielmorris11111@gmail.com
Received: by 2002:a05:6638:1248:0:0:0:0 with HTTP; Mon, 31 Jan 2022 03:00:07
 -0800 (PST)
From:   Mrs daniell akyle <daniellakyle60@gmail.com>
Date:   Mon, 31 Jan 2022 12:00:07 +0100
X-Google-Sender-Auth: juhwXopT4FowK4J6T8rApuMl0w4
Message-ID: <CAKFcj-OsHQc6b32Puiy4zbkpRh0TFP-Vu0BdoENoHiCXtxRwQQ@mail.gmail.com>
Subject: Ahoj
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Pozdravy
Jmenuji se pan=C3=AD Daniella Kyleov=C3=A1, je mi 58 let
Filip=C3=ADny. V sou=C4=8Dasn=C3=A9 dob=C4=9B jsem hospitalizov=C3=A1n na F=
ilip=C3=ADn=C3=A1ch, kde jsem
podstupuje l=C3=A9=C4=8Dbu akutn=C3=ADho karcinomu j=C3=ADcnu. jsem um=C3=
=ADraj=C3=ADc=C3=AD,
vdova, kter=C3=A1 se rozhodla darovat =C4=8D=C3=A1st sv=C3=A9ho majetku spo=
lehliv=C3=A9 osob=C4=9B
kter=C3=A1 tyto pen=C3=ADze pou=C5=BEije na pomoc chud=C3=BDm a m=C3=A9n=C4=
=9B privilegovan=C3=BDm. Chci
poskytnout dar ve v=C3=BD=C5=A1i 3 700 000 =C2=A3 na sirotky nebo charitati=
vn=C3=AD organizace
ve va=C5=A1=C3=AD oblasti. Zvl=C3=A1dne=C5=A1 to? Pokud jste ochotni tuto n=
ab=C3=ADdku p=C5=99ijmout
a ud=C4=9Blejte p=C5=99esn=C4=9B tak, jak v=C3=A1m =C5=99=C3=ADk=C3=A1m, pa=
k se mi vra=C5=A5te pro dal=C5=A1=C3=AD vysv=C4=9Btlen=C3=AD.
pozdravy
Pan=C3=AD Daniella Kyleov=C3=A1
