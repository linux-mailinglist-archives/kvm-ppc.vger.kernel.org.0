Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3754E3E6F
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Mar 2022 13:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbiCVMZO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Mar 2022 08:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiCVMZO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Mar 2022 08:25:14 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BD47891D
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Mar 2022 05:23:46 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v130-20020a1cac88000000b00389d0a5c511so2078111wme.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Mar 2022 05:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=Pm04dP0+P83KVn44y+vrJDsQ3iwP6pKc5n+Js9E3oKk=;
        b=VkkmHWPb5uXsSuxmWIB8FGFTWJYgrlZ1SwDn7lLHVDQx/v6mfHXgtlR2RQR88NPWcy
         B0GZ/6svZEQG6ndLKBeuLHt0snNtw8Hafj6MtV/uOMw6Plv350iHjMjxU29s4IOl+7Pi
         PUwGKpo3Bbubtg6/FvEbdQfmmc9NrEY4YVkYBbqKFAyuT4Tp+G4eXAPuga0D+6JJq1GG
         oU8xSmM/A5XSkQv7BwH//V5atUSDxzmBd+AAh5vhG1I7qsUux3YMoKQYXHoufiQTiRif
         iGDFROApfDq4NLw0rkfqx806c0Ug2LhudjOps6Ufkz+7J0+wo5uDMi38z8rHyosOE5I6
         vPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=Pm04dP0+P83KVn44y+vrJDsQ3iwP6pKc5n+Js9E3oKk=;
        b=bxgVCJhaIQ/7KHuYci1BPr5u+TmK+8NI9eEWWJZre46oUcKL0upUERB9zlYfubz8Ui
         HIXsn2J+ska2pUgbNaGyMsYKkGUoFHeVS6mjPLKHqRhRR33tKi1KDlAuFrapxFm0/5go
         uOxsDk9NGbuWAl/nXGgooTIrrkPN9XV2NBDa0zlItwxwoxh7cdsCljrS48YfUS2xAMVL
         J/pEofToqHDv2g2uLvJ034NkXMx4Jiodvd1ahQB0IPhZCgO4k2+tVlPF04QOP9NDLzM6
         nh4amWyrDMJYpFHeKsmhox+7nven2HX/sz3fYumUhvJreFDYxK89u3ulcyIXCH8Hitey
         FUdw==
X-Gm-Message-State: AOAM5320mrQ0MC+sxEvrWNeRU3PCu17HFWe8lK0IX3aky4thRyagyjvZ
        F3/KT3bkgpZd6eibsZO2Xdk=
X-Google-Smtp-Source: ABdhPJzhogdnSE3Dm75218hWwdx0tx/xusaVT18WXoPBq/vEOHZWoV9x2AKdq+OpyouGQzvSGpf27Q==
X-Received: by 2002:a05:600c:3ca8:b0:38c:6dc6:6de0 with SMTP id bg40-20020a05600c3ca800b0038c6dc66de0mr3538840wmb.159.1647951824864;
        Tue, 22 Mar 2022 05:23:44 -0700 (PDT)
Received: from [192.168.43.30] ([197.211.61.62])
        by smtp.gmail.com with ESMTPSA id l19-20020a05600c4f1300b0038cb924c3d7sm1206553wmq.45.2022.03.22.05.23.37
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 22 Mar 2022 05:23:44 -0700 (PDT)
Message-ID: <6239bfd0.1c69fb81.45ba9.5386@mx.google.com>
From:   veriahollinkvan@gmail.com
X-Google-Original-From: eriahollinkvan@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: meine Spende
To:     eriahollinkvan@gmail.com
Date:   Tue, 22 Mar 2022 05:23:27 -0700
Reply-To: mariaelisabethschaeffler70@gmail.com
X-Spam-Status: No, score=3.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

 Hallo,

Ich bin Frau Maria Elisabeth Schaeffler, eine deutsche Gesch=E4ftsmagnatin,=
 Investorin und Philanthropin. Ich bin der Vorsitzende von Wipro Limited. I=
ch habe 25 Prozent meines pers=F6nlichen Verm=F6gens f=FCr wohlt=E4tige Zwe=
cke ausgegeben. Und ich habe auch versprochen, den Rest von 25% in diesem J=
ahr 2021 an Einzelpersonen zu verschenken. Ich habe beschlossen, Ihnen 1.50=
0.000,00 Euro zu spenden. Wenn Sie an meiner Spende interessiert sind, kont=
aktieren Sie mich f=FCr weitere Informationen.


Sie k=F6nnen auch mehr =FCber mich =FCber den unten stehenden Link lesen

https://en.wikipedia.org/wiki/Maria-Elisabeth_Schaeffler

Sch=F6ne Gr=FC=DFe

Gesch=E4ftsf=FChrer Wipro Limited

Maria Elisabeth Schaeffler

E-Mail: mariaelisabethschaeffler70@gmail.com
