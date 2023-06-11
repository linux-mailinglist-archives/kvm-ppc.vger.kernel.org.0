Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C41B72C296
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Jun 2023 13:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbjFLLM0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Jun 2023 07:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbjFLLMN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Jun 2023 07:12:13 -0400
X-Greylist: delayed 29882 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Jun 2023 04:01:05 PDT
Received: from mail1.ceniai.inf.cu (mail1.ceniai.inf.cu [169.158.128.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 599C944AB;
        Mon, 12 Jun 2023 04:01:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail1.ceniai.inf.cu (Postfix) with ESMTP id 51D684E5CE3;
        Sun, 11 Jun 2023 22:28:31 -0400 (EDT)
X-Virus-Scanned: amavisd-new at mail1.ceniai.inf.cu
Received: from mail1.ceniai.inf.cu ([127.0.0.1])
        by localhost (mail1.ceniai.inf.cu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id paPhztHpeGcE; Sun, 11 Jun 2023 22:28:31 -0400 (EDT)
Received: from mail.vega.inf.cu (mail.vega.inf.cu [169.158.143.34])
        by mail1.ceniai.inf.cu (Postfix) with ESMTP id 217A258D942;
        Sun, 11 Jun 2023 20:59:20 -0400 (EDT)
Received: from mx1.ecovida.cu (unknown [169.158.179.26])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail.vega.inf.cu (Postfix) with ESMTPS id A939C42EF34;
        Sun, 11 Jun 2023 07:42:33 -0400 (CDT)
Received: from mx1.ecovida.cu (localhost [127.0.0.1])
        by mx1.ecovida.cu (Proxmox) with ESMTP id 4A944240AF7;
        Sun, 11 Jun 2023 11:26:14 -0400 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ecovida.cu; h=cc
        :content-description:content-transfer-encoding:content-type
        :content-type:date:from:from:message-id:mime-version:reply-to
        :reply-to:subject:subject:to:to; s=ecovida20; bh=eJCLj5LjLfltOUH
        QwbhnEIM71NnOqC+k0uTJlyqNYA0=; b=eMNkF6x6XTNijmZQek9cjN9g4hFpQeM
        r2pkiiP3KmqVY+9cbXamlnSXMYs0aC4KPOuRLEnuAh0LYQCvHj69QiQ7JPgnaxEJ
        4ko213Oo0ofch2j3yBYtkPa2EjMDJfnGu9Fy8F22uMOI3VqXDLhSoD2vsTkNpbOo
        nNS2qsayCe+LuU2a9TpB5a16h4QteiyO6QfUjr2jQDb5zXK8jDV6NdwODN1mA4k2
        NUVukeltHWvwWfND7EHgkfXiiSiNL23JxXtYwk4dptWdeU6mkO2sD54eJ+tZyfQw
        t7OYk3YQT1IZ5skhilBcXL2RtLDwXD64CGCE5c5mIkv7VcFc/CvlNxA==
Received: from correoweb.ecovida.cu (correoweb.ecovida.cu [192.168.100.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mx1.ecovida.cu (Proxmox) with ESMTPS id 3C27F2408F1;
        Sun, 11 Jun 2023 11:26:14 -0400 (CDT)
Received: from localhost (localhost [127.0.0.1])
        by correoweb.ecovida.cu (Postfix) with ESMTP id 9807D4B56A2;
        Sun, 11 Jun 2023 11:14:25 -0400 (CDT)
Received: from correoweb.ecovida.cu ([127.0.0.1])
        by localhost (correoweb.ecovida.cu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Qxkt3G7Oo99J; Sun, 11 Jun 2023 11:14:25 -0400 (CDT)
Received: from localhost (localhost [127.0.0.1])
        by correoweb.ecovida.cu (Postfix) with ESMTP id 0D8874A9D6F;
        Sun, 11 Jun 2023 10:29:19 -0400 (CDT)
X-Virus-Scanned: amavisd-new at ecovida.cu
Received: from correoweb.ecovida.cu ([127.0.0.1])
        by localhost (correoweb.ecovida.cu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZAxyEl_WlrVT; Sun, 11 Jun 2023 10:29:18 -0400 (CDT)
Received: from [192.168.100.9] (unknown [45.88.97.218])
        by correoweb.ecovida.cu (Postfix) with ESMTPSA id 1DBC84B5026;
        Sun, 11 Jun 2023 09:36:59 -0400 (CDT)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: RE:
To:     Recipients <lazaroluis@ecovida.cu>
From:   Aldi Albrecht <lazaroluis@ecovida.cu>
Date:   Sun, 11 Jun 2023 14:41:10 +0100
Reply-To: aldiheister@gmail.com
X-Antivirus: Avast (VPS 230611-4, 6/11/2023), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20230611133700.1DBC84B5026@correoweb.ecovida.cu>
X-Spam-Status: Yes, score=6.1 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,NIXSPAM_IXHASH,RCVD_IN_MSPIKE_BL,
        RCVD_IN_MSPIKE_ZBI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  3.0 NIXSPAM_IXHASH http://www.nixspam.org/
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        *  0.0 RCVD_IN_MSPIKE_BL Mailspike blocklisted
        *  0.0 RCVD_IN_MSPIKE_ZBI No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hallo gesch=E4tzter Beg=FCnstigter, Sie wurden f=FCr eine gro=DFe Geldsumme=
 f=FCr humanit=E4re und Investitionszwecke jeglicher Art ausgew=E4hlt. F=FC=
r weitere Details antworten Sie bitte.

Gr=FC=DFe
 
Beate Heister
Eigent=FCmer
Aldi Albrecht-TRUST

-- 
This email has been checked for viruses by Avast antivirus software.
www.avast.com

