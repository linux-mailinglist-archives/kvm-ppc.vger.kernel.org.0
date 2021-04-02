Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8697D352443
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 02:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhDBAL6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 20:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhDBAL6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 20:11:58 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103B1C0613E6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 17:11:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f17so1819182plr.0
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 17:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=w+uMm5y81TmVu99pulguuZSef2iVnhjsZnzedjRmtbY=;
        b=QbZg4me4ZDg4cfJe30HhdatXAhn6SOBUFAgSLPG3RGmd51dFkaVQ78R6DdWlow0dRC
         cwxfLegYTTiIomjnyF+b8+4WgP9tt/si0Rk2JAHDC5//GimV9SOHpGksxO3tVDiizgRi
         MkKV9tor4YaWoYHY5Vss5Xv/7mFhKKyVnrSq1wkURV+BQVyDO0DqZdfyviBp32yYD3my
         z3I6HMzO1ZQkIG6tb60NfvdohRbfI2fFGsr9Zk/BRdEmP7BOzEL4ZUBWbeV9hI2Q56R5
         rjWqnqnW2kTRLf3vvuZILSzidtFeeuS8UdU9WLvmcI7IwDULw3hOsv1ftVEnSpzVelLJ
         hnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=w+uMm5y81TmVu99pulguuZSef2iVnhjsZnzedjRmtbY=;
        b=aFJJrMFcnkyjO+ya6dsBiqw7gMgm68kAkedxuzZp0ONbQQJrKBpvsPoi+KB/7IFW5X
         vDl377NbIiZipP16G+KyCZe8jb8bARCOSEp/lfU3SNAhgxnRyOQ+em9hpi0rdpgCzYbt
         rb534l5SUHThMETDFgG6BMqu3TO2qymWNbkrFpcm+IKS9sGC0T2oBQ7SQmSIzSqMtHLw
         +9qDBflJUYGtRTnOrD4Z5jsXFovTZ/vlW37vwl/y5IHJtahT742FXRhInTaYwNigxX+4
         uIRzaPJOTKdqMuGyK452+c0v8s37Dd7mxiFbDLfI7uk+guzb8EMvt3RMNAZZok8bZJEE
         v6tw==
X-Gm-Message-State: AOAM533Rq6DXeMFCi8lGk+ZkJ1p4CegC9PhmmwA6um5qJiEOaUDD342+
        EsXmDDPwThHOgXPjH3kVD2o6aKDWPKUkkA==
X-Google-Smtp-Source: ABdhPJwMGaevZkWpnNq2jucx6RURBC9dU+jVdIlSiN1GrAG5inc1FiNUq146dfQ2xYbfzoWtybYqUg==
X-Received: by 2002:a17:902:c389:b029:e7:1029:8ba5 with SMTP id g9-20020a170902c389b02900e710298ba5mr10253384plg.55.1617322316521;
        Thu, 01 Apr 2021 17:11:56 -0700 (PDT)
Received: from localhost ([1.128.156.122])
        by smtp.gmail.com with ESMTPSA id w15sm35493pja.18.2021.04.01.17.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 17:11:56 -0700 (PDT)
Date:   Fri, 02 Apr 2021 10:11:49 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 48/48] KVM: PPC: Book3S HV: remove ISA v3.0 and v3.1
 support from P7/8 path
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210401150325.442125-1-npiggin@gmail.com>
        <20210401150325.442125-49-npiggin@gmail.com>
In-Reply-To: <20210401150325.442125-49-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1617322040.20cd3hcyo5.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of April 2, 2021 1:03 am:
> POWER9 and later processors always go via the P9 guest entry path now.
> Remove the remaining support from the P7/8 path.
>=20
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

[...]

> @@ -2527,28 +2259,14 @@ BEGIN_FTR_SECTION
>  END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
> =20
>  kvm_nap_sequence:		/* desired LPCR value in r5 */
> -BEGIN_FTR_SECTION
> -	/*
> -	 * PSSCR bits:	exit criterion =3D 1 (wakeup based on LPCR at sreset)
> -	 *		enable state loss =3D 1 (allow SMT mode switch)
> -	 *		requested level =3D 0 (just stop dispatching)
> -	 */
> -	lis	r3, (PSSCR_EC | PSSCR_ESL)@h
>  	/* Set LPCR_PECE_HVEE bit to enable wakeup by HV interrupts */
>  	li	r4, LPCR_PECE_HVEE@higher
>  	sldi	r4, r4, 32
>  	or	r5, r5, r4
> -FTR_SECTION_ELSE
> -	li	r3, PNV_THREAD_NAP

^^^^^^^

> -ALT_FTR_SECTION_END_IFSET(CPU_FTR_ARCH_300)
>  	mtspr	SPRN_LPCR,r5
>  	isync
> =20
> -BEGIN_FTR_SECTION
> -	bl	isa300_idle_stop_mayloss
> -FTR_SECTION_ELSE
>  	bl	isa206_idle_insn_mayloss
> -ALT_FTR_SECTION_END_IFSET(CPU_FTR_ARCH_300)

Got a bug or two in the old path because I didn't test SMT configs.

I'll work through those so for now don't spend too much time trying to=20
run the old path or going through the rmhandlers.S asm changes in the=20
series until I post the next round.

Thanks,
Nick
