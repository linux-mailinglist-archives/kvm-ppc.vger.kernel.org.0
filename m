Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9A04ECA7A
	for <lists+kvm-ppc@lfdr.de>; Wed, 30 Mar 2022 19:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235457AbiC3RYk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 30 Mar 2022 13:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiC3RYj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 30 Mar 2022 13:24:39 -0400
X-Greylist: delayed 3594 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Mar 2022 10:22:52 PDT
Received: from zsmtp-out1.bppt.go.id (zsmtp-in1.bppt.go.id [103.224.137.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BAA11C11;
        Wed, 30 Mar 2022 10:22:52 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zsmtp-out1.bppt.go.id (Postfix) with ESMTP id 651D087B1C;
        Wed, 30 Mar 2022 22:41:24 +0700 (WIB)
Received: from zsmtp-out1.bppt.go.id ([127.0.0.1])
        by localhost (zsmtp-out1.bppt.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id yyTy9AnQPwON; Wed, 30 Mar 2022 22:41:23 +0700 (WIB)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by zsmtp-out1.bppt.go.id (Postfix) with ESMTP id 1D5968769B;
        Wed, 30 Mar 2022 22:41:21 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 zsmtp-out1.bppt.go.id 1D5968769B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bppt.go.id;
        s=selector; t=1648654881;
        bh=VyNFlD7/cu41Triwpcp5Awv70tSUbdDqwtfboErdO+g=;
        h=Date:From:Message-ID:MIME-Version;
        b=CDZBw2B6e3/HK2o2T4YC4hke8dpLa0TEQWpClEX9KVIi7U7+vih3QsGPGHeTqOfhz
         i7jGOGWug5Rr9gtAFwSQF1LlArm8GO5t+1bRgXleb4wY77/sfxciuu5TO3SmDpa4/k
         trzmQR0s+wG38tFuJ2+LQmG6hn6x3obYZpFfFzE8=
X-Amavis-Modified: Mail body modified (using disclaimer) -
        zsmtp-out1.bppt.go.id
X-Virus-Scanned: amavisd-new at bppt.go.id
Received: from zsmtp-out1.bppt.go.id ([127.0.0.1])
        by localhost (zsmtp-out1.bppt.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GmNRWCKsnvad; Wed, 30 Mar 2022 22:41:20 +0700 (WIB)
Received: from mta1.bppt.go.id (mta1.bppt.go.id [10.10.180.6])
        by zsmtp-out1.bppt.go.id (Postfix) with ESMTPS id 1886587B08;
        Wed, 30 Mar 2022 22:41:18 +0700 (WIB)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta1.bppt.go.id (Postfix) with ESMTP id D22B1253E7;
        Wed, 30 Mar 2022 22:41:14 +0700 (WIB)
Received: from mta1.bppt.go.id ([127.0.0.1])
        by localhost (mta1.bppt.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id VtEi4-DhOobs; Wed, 30 Mar 2022 22:41:14 +0700 (WIB)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta1.bppt.go.id (Postfix) with ESMTP id 7D03525415;
        Wed, 30 Mar 2022 22:41:08 +0700 (WIB)
X-Virus-Scanned: amavisd-new at mta1.bppt.go.id
Received: from mta1.bppt.go.id ([127.0.0.1])
        by localhost (mta1.bppt.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tdAiWG5_8gpb; Wed, 30 Mar 2022 22:41:07 +0700 (WIB)
Received: from mbox2.bppt.go.id (mbox2.bppt.go.id [10.10.180.5])
        by mta1.bppt.go.id (Postfix) with ESMTP id 4B2A125406;
        Wed, 30 Mar 2022 22:40:52 +0700 (WIB)
Date:   Wed, 30 Mar 2022 22:40:52 +0700 (WIB)
From:   Nadirah <nadirah@bppt.go.id>
Reply-To: huangjinping@winghang.info
Message-ID: <332096518.4896872.1648654852192.JavaMail.zimbra@bppt.go.id>
Subject: Aw:Dringende Antwort erforderlich
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.15_GA_4101 (zclient/8.8.15_GA_4101)
Thread-Index: NAMa8Zgh+tp2gXu+wyXdyv10+CeanQ==
Thread-Topic: Dringende Antwort erforderlich
X-Spam-Status: No, score=3.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIME_QP_LONG_LINE,
        MISSING_HEADERS,REPLYTO_WITHOUT_TO_CC,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



Es tut mir leid, dass ich Ihnen diese E-Mail, die in Ihrem Junk-Ordner eing=
egangen ist, als unerw=C3=BCnschte E-Mail gesendet habe. Ich hei=C3=9Fe Hua=
ng Jinping. Ich habe einen Gesch=C3=A4ftsvorschlag f=C3=BCr Sie. Ich wei=C3=
=9F, dass dieser Gesch=C3=A4ftsvorschlag f=C3=BCr Sie von Interesse sein w=
=C3=BCrde. F=C3=BCr weitere Informationen kontaktieren Sie mich bitte *****=
***************************************************************************=
**********#################################################################=
####################################
Isi e-mail ini mungkin bersifat rahasia dan penyalahgunaan, penyalinan, atau penyebaran dari e-mail ini dan semua attachment dari e-mail ini dilarang. Komunikasi internet tidak aman dan oleh karena itu Badan Pengkajian dan Penerapan Teknologi tidak menerima tanggung jawab hukum atas isi pesan ini atau untuk setiap kerusakan yang disebabkan oleh virus. Pendapat-pendapat yang diungkapkan di sini tidak selalu mewakili Badan Pengkajian dan Penerapan Teknologi.

