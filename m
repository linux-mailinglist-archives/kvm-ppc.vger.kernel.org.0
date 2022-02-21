Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F154A4BE2AC
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Feb 2022 18:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376675AbiBUNxb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Feb 2022 08:53:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376986AbiBUNwz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Feb 2022 08:52:55 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F73DBF73
        for <kvm-ppc@vger.kernel.org>; Mon, 21 Feb 2022 05:52:32 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v12so27245057wrv.2
        for <kvm-ppc@vger.kernel.org>; Mon, 21 Feb 2022 05:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=FyG0ATSkb5fmrso4VuDc0KiEUJrvvMWML2pstdAYUxY=;
        b=eVsbK/FpL7s5urLXB3/hDLoaRFWo7sI+v6Aj0tNZUlfQbZYSRGHo4cVbumr9eKWo+r
         9NHAjQQZxChoLnLNTI7iuLXEtwnbrDMPBhSIx8gVtQbTIzPRg4E4GPv9iGZJ7ePtQIj4
         Q46RhvWu1agsqgRCdMg20XO7NMJ8SfLZ3MlxIBdpPATbUlocCtSJBOPj3A3E6BHzWVA9
         TjgCKiJ34giBKxgfUephvmlTytPrfGhkaw+6UPeMDW3bvJm0vzpJTj8NcLQcS3g7RfGV
         abI496KPoZKJrGICYsEp4XWyAYFKIA7/FIvkCOhj9DKs7FnqEl6p6JZgri1zSecMppLV
         5QoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=FyG0ATSkb5fmrso4VuDc0KiEUJrvvMWML2pstdAYUxY=;
        b=GuFgeAVXDObq1QD8jyOUDznt/VIX4mqGUekECmeCH77FfeYyx3cXn1SJiW3Cn1+9ao
         8BWfW4Yq9Z/zYf7psb+KEbnuDUnfEmyjlETrUQWlzquyDq8HfgBarCEsiRktuTiOT3HI
         Fti7szGQr1u3NbSAbLM1HurensA0R70D0NdpBNaa/lzj919clVFZFoCsBepSEApmycgo
         PXrXTPuz7c+9v8z3lLZeiY0hZFhtNAaRRLrCQFUnZ+fYB6ZhLw1mOz6+JR27p3hjM7Hp
         xDPWJVWxkrqdeIwlz7bjPV7M4DIUmMZqv93C4tVOCDjh4INl0QDHLqLZWYi+sumwh5jB
         xuyw==
X-Gm-Message-State: AOAM531j3m5LTZxzfK1qETTbKmAxymLgGN5poXZhh1XFTi5NqL2LtnOn
        6Zc6u5G7NfkSOy/8LAXI96M=
X-Google-Smtp-Source: ABdhPJxaxIA0OKu56QE3q73Td9MOg0qmb+CE8pvGmLGQLsDxy2Ki/3c1KYKii+p1ujDCG3NbpnZUxw==
X-Received: by 2002:adf:f109:0:b0:1e3:e2d:e6e0 with SMTP id r9-20020adff109000000b001e30e2de6e0mr15718603wro.177.1645451551142;
        Mon, 21 Feb 2022 05:52:31 -0800 (PST)
Received: from [192.168.0.133] ([5.193.8.34])
        by smtp.gmail.com with ESMTPSA id u11sm52120119wrt.108.2022.02.21.05.52.27
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 21 Feb 2022 05:52:30 -0800 (PST)
Message-ID: <6213991e.1c69fb81.91cb9.8449@mx.google.com>
From:   Mrs Maria Elisabeth Schaeffler <briankevin154@gmail.com>
X-Google-Original-From: Mrs Maria Elisabeth Schaeffler
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Spende
To:     Recipients <Mrs@vger.kernel.org>
Date:   Mon, 21 Feb 2022 17:52:23 +0400
Reply-To: mariaeisaeth001@gmail.com
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,TO_MALFORMED,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hallo,

Ich bin Frau Maria Elisabeth Schaeffler, eine deutsche Wirtschaftsmagnatin,=
 Investorin und Philanthropin. Ich bin der Vorsitzende von Wipro Limited. I=
ch habe 25 Prozent meines pers=F6nlichen Verm=F6gens f=FCr wohlt=E4tige Zwe=
cke ausgegeben. Und ich habe auch versprochen zu geben
der Rest von 25% geht dieses Jahr 2021 an Einzelpersonen. Ich habe mich ent=
schlossen, Ihnen 1.500.000,00 Euro zu spenden. Wenn Sie an meiner Spende in=
teressiert sind, kontaktieren Sie mich f=FCr weitere Informationen.

Sie k=F6nnen auch =FCber den untenstehenden Link mehr =FCber mich lesen


https://en.wikipedia.org/wiki/Maria-Elisabeth_Schaeffler

Sch=F6ne Gr=FC=DFe
Gesch=E4ftsf=FChrer Wipro Limited
Maria-Elisabeth_Schaeffler
Email: mariaeisaeth001@gmail.com=20
