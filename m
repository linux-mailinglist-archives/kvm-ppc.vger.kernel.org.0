Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEEE2282F7
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jul 2020 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgGUPAN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 11:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgGUPAM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 11:00:12 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F40C061794
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jul 2020 08:00:12 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y3so4173174wrl.4
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jul 2020 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=gkcdZTp2vhYAj6bOy4b93mUdztEgbAoKRStl6TIAF08=;
        b=R9RGlsgqzV6dj+XgA5tLGi4k+d6eegdhlMqHNZSTpznh+TqDXoiyuhz+daPZSJfUYa
         /4a5pa1wa2Y0goWjd+Wrwn4odA33wh6Z35ODwUBhsDDq83R1Zlh7EdhMFytzEk7aCdCC
         qGtbZTvfbdaHEagPT16HzRuSvceREEgOzsPRaCHFS0N77rfaNhkBR7giM5gyYmCJ/2eP
         Iy3cRScwAcIL0f13FWZvF3xxr5iu9ypG+dGAufGXtT3uxa/sNmS1Qui0oBd525kp9JuK
         7um+mMi/c6X6A6bYMRI7kejfTJkTWfOgSvdyx1xKm9q6TfHZFOpwC9eI0nqK2km0oWW6
         iEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=gkcdZTp2vhYAj6bOy4b93mUdztEgbAoKRStl6TIAF08=;
        b=EEbpElYMtOekspNioyres32jVxeZRIMusDu7BqDzK/Vfw7JR+UJuGX3s4nq3Abo4W0
         /pp7usWKh/tujwJFNVTrm5I67DXSbKy+cPkqMcq1zr+RJu8K32RHCXFW6A97FyUgCHma
         YLlLm/BemXvhu40Yfo9EW+7dz9V+0XC48sZzI8AJ500d+viNqEXQj5SSoEiebLiXgqtQ
         YOktjPJ+kX2aEY+JwyPgnSQuUi6WnCL7t8s2R/+K56BztJJ3hp6wnlgD2HilUj7d2/Mn
         IxuXM3AILi9HmK4w8htz7zT5pwb51931WW00YANyaZZT9HP1gPaK8tE/69b5eNgigdbN
         Z6DA==
X-Gm-Message-State: AOAM533BoSKicfkWbf1Eo528zueICJdDnLUJZ6zjdcz5qb9Y6mkeReKb
        wfJ4BdBtnQxhVaUMr+fwtoempGHT
X-Google-Smtp-Source: ABdhPJzTxDMzbVi+0xwmEzR8lYOBJgczo5MbDu5Ifcdk7/gzjbnhYsKoNgqiQ9aaWprfNpNJ/dSBoQ==
X-Received: by 2002:adf:bc07:: with SMTP id s7mr13029096wrg.254.1595343611129;
        Tue, 21 Jul 2020 08:00:11 -0700 (PDT)
Received: from localhost (110-174-173-27.tpgi.com.au. [110.174.173.27])
        by smtp.gmail.com with ESMTPSA id n5sm3722564wmi.34.2020.07.21.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 08:00:10 -0700 (PDT)
Date:   Wed, 22 Jul 2020 01:00:04 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on
 MMIO access, in sprg0 register
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Ram Pai <linuxram@us.ibm.com>
Cc:     aik@ozlabs.ru, bauerman@linux.ibm.com, bharata@linux.ibm.com,
        david@gibson.dropbear.id.au, ldufour@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
In-Reply-To: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Message-Id: <1595342553.d7hx0ljll3.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Ram Pai's message of July 16, 2020 6:32 pm:
> An instruction accessing a mmio address, generates a HDSI fault.  This fa=
ult is
> appropriately handled by the Hypervisor.  However in the case of secureVM=
s, the
> fault is delivered to the ultravisor.

Why not a ucall if you're paraultravizing it anyway?

>=20
> Unfortunately the Ultravisor has no correct-way to fetch the faulting
> instruction. The PEF architecture does not allow Ultravisor to enable MMU
> translation. Walking the two level page table to read the instruction can=
 race
> with other vcpus modifying the SVM's process scoped page table.
>=20
> This problem can be correctly solved with some help from the kernel.
>=20
> Capture the faulting instruction in SPRG0 register, before executing the
> faulting instruction. This enables the ultravisor to easily procure the
> faulting instruction and emulate it.
>=20
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  arch/powerpc/include/asm/io.h | 85 +++++++++++++++++++++++++++++++++++++=
+-----
>  1 file changed, 75 insertions(+), 10 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.=
h
> index 635969b..7ef663d 100644
> --- a/arch/powerpc/include/asm/io.h
> +++ b/arch/powerpc/include/asm/io.h
> @@ -35,6 +35,7 @@
>  #include <asm/mmu.h>
>  #include <asm/ppc_asm.h>
>  #include <asm/pgtable.h>
> +#include <asm/svm.h>
> =20
>  #define SIO_CONFIG_RA	0x398
>  #define SIO_CONFIG_RD	0x399
> @@ -105,34 +106,98 @@
>  static inline u##size name(const volatile u##size __iomem *addr)	\
>  {									\
>  	u##size ret;							\
> -	__asm__ __volatile__("sync;"#insn" %0,%y1;twi 0,%0,0;isync"	\
> -		: "=3Dr" (ret) : "Z" (*addr) : "memory");			\
> +	if (is_secure_guest()) {					\
> +		__asm__ __volatile__("mfsprg0 %3;"			\
> +				"lnia %2;"				\
> +				"ld %2,12(%2);"				\
> +				"mtsprg0 %2;"				\
> +				"sync;"					\
> +				#insn" %0,%y1;"				\
> +				"twi 0,%0,0;"				\
> +				"isync;"				\
> +				"mtsprg0 %3"				\

We prefer to use mtspr in new code, and the nia offset should be=20
calculated with a label I think "(1f - .)(%2)" should work.

SPRG usage is documented in arch/powerpc/include/asm/reg.h if this=20
goes past RFC stage. Looks like SPRG0 probably could be used for this.

Thanks,
Nick
