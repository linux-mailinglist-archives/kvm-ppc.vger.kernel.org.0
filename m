Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998F5792888
	for <lists+kvm-ppc@lfdr.de>; Tue,  5 Sep 2023 18:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243165AbjIEQW4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 5 Sep 2023 12:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353815AbjIEITO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 5 Sep 2023 04:19:14 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ECBE42
        for <kvm-ppc@vger.kernel.org>; Tue,  5 Sep 2023 01:19:05 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-649c6ea6e72so13510986d6.2
        for <kvm-ppc@vger.kernel.org>; Tue, 05 Sep 2023 01:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693901944; x=1694506744; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CvUmRYKO5rN5JiKdYLn9/Xxm/soJiVGtQm650JnL3Yc=;
        b=IDuf0baB1t1F8QSCLjWC8pmRvzAKQ/R4M4t5u3FLsOX2SqRgQXz/Z3MpAk8Vd5Kb6m
         OBaz+r/ujIbUuNkrji3TkmDn2dTAwQpGpPSmDRQp7o69pvQ/Nlbne7CwWkb0CdLrrzzk
         IN5sVqz4WX/cEw2uA94JE67yTGlOm8wzR3yOF0SXEPyJnQGBjepPHYJlqPiS3zq3DGfU
         I2yXoCdrDFdm20VoyBK97sKFjeM/5AIhQp1In2otrpCJ9z7tTsw9ci7s0XR+LUbYUzXt
         uod929b61k889o1RxRCphXZmWycOoUHC60HIKvs/decRlJjUBc58LQQ4Se5bQ0loDS6t
         OnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693901944; x=1694506744;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvUmRYKO5rN5JiKdYLn9/Xxm/soJiVGtQm650JnL3Yc=;
        b=NoMyO+M3yt6T4X1Znb18HDalr7iE6GJhYOwvAmcuw9y9ujiM3qGuUVwdsFQVXLOhIh
         uLJ77V6HTwYteLHD783sc4cOkm95qw4vNmQkuRU1YCh8b2cFOf3uH3eRclsk27AJ31f6
         qtQlNBYJpSBQ9953ol9V+E4/trJEQfiDDj69vfN665ZjgA89Bsm2xsEL8HetCsDtjNQC
         HL/Cs48KgSBq5+RBfYOSN6yDo0L2yfg+sjZB5zZBTQPrMKnh2qL+k4OOocBVtJz5t8k7
         k+JwcIxEgipjY6jqdAEVR5rBvw3auas/MyojPhwT6UlDe00b+opbBpfiOFnENwl18OuS
         +JKg==
X-Gm-Message-State: AOJu0YzX0zG/WSeEPzfUuIF5d7/u1uSM1/X/YCYJfW2nTNQtkCA5biLa
        h9Ml1XUqwmoIs9gtgXWXv1uE7PrCqwefWdf7fKE=
X-Google-Smtp-Source: AGHT+IERAX8PQb3+O/VRt2IpdT+B8+AIRhc7TR9qfBXEywqtD/tUeMqNmseulSPs3fS452xIhVN8tbhQYqX1LXl34po=
X-Received: by 2002:a0c:aa1b:0:b0:653:5736:c0b4 with SMTP id
 d27-20020a0caa1b000000b006535736c0b4mr10412089qvb.54.1693901943569; Tue, 05
 Sep 2023 01:19:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a0c:de0e:0:b0:634:8588:8dcb with HTTP; Tue, 5 Sep 2023
 01:19:02 -0700 (PDT)
Reply-To: wuwumoneytransfer5000@hotmail.com
From:   "(IMF) SCAM VICTIMS" <smmab4668@gmail.com>
Date:   Tue, 5 Sep 2023 01:19:02 -0700
Message-ID: <CAPvhgiGb_xchv+cBfjtNXZbs3T38s2BJRqmONSNBDUeOvUkr=Q@mail.gmail.com>
Subject: Betrugsopfer
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sehr geehrter E-Mail-Besitzer,



Der Internationale W=C3=A4hrungsfonds (IWF) entsch=C3=A4digt alle Betrugsop=
fer
und Ihre E-Mail-Adresse wurde auf der Liste der Betrugsopfer gefunden.

Dieses Western Union-B=C3=BCro wurde vom IWF beauftragt Ihnen Ihre
Verg=C3=BCtung per Western Union Money Transfer zu =C3=BCberweisen.

Wir haben uns jedoch entschieden Ihre eigene Zahlung =C3=BCber Geldtransfer
der Westunion in H=C3=B6he von =E2=82=AC5,000, pro Tag vorzunehmen bis die
Gesamtsumme von =E2=82=AC1,500.000.00, vollst=C3=A4ndig an Sie =C3=BCberwie=
sen wurde.

Wir k=C3=B6nnen die Zahlung m=C3=B6glicherweise nicht nur mit Ihrer
E-Mail-Adresse senden daher ben=C3=B6tigen wir Ihre Informationen dar=C3=BC=
ber
wohin wir das Geld an Sie senden wie z. B.:


Name des Adressaten ________________

Adresse________________

Land__________________

Telefonnummer________________

Angeh=C3=A4ngte Kopie Ihres Ausweises______________

Das Alter ________________________


Wir beginnen mit der =C3=9Cbertragung sobald wir Ihre Informationen
erhalten haben: Kontakt E-Mail: ( wuwumoneytransfer5000@hotmail.com)


Getreu,


Herr Anthony Duru,

Direktor von Geldtransfer der Westunion
