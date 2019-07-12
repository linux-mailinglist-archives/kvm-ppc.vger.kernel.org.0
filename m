Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3C266334
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Jul 2019 03:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfGLBBE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 21:01:04 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33874 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGLBBE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Jul 2019 21:01:04 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so3919051plt.1
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Jul 2019 18:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=rTHh49zFDfiIVfDIG3rz9XjewOEXeu4oLsIHe9cSEx8=;
        b=KwVnI2hAaKJwmrbieymmtiw3VbIfPeh2tQIrhPXD6Lkm0/1DYpAiJ5hdcE1pfdizLG
         clwUrftFSyeGpN5BBWgx+gHfLkew8X7SZ0LWTZn0LZ5Pv4Cr8T4sjar5HQxp588/ZvAD
         hEKfJWo18BuX+D5nvMUzrxFcYbrier0imRaRSBxTwJvBLsJNVqjRHR5X0lGMWBSG+eYF
         eeyik31OrXY/kFf+ok+XLh9j5QPmIU6lXnNYLatAGI91t41QAsB55AaqU5rpWtsoVKmr
         c0skPFp8k5zQZFRF9IRUVyHDQDJNISz6o3t9WRsPIfaD5MmjwIrvZ+pYrw17fKzI9nhm
         ts2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=rTHh49zFDfiIVfDIG3rz9XjewOEXeu4oLsIHe9cSEx8=;
        b=ksVmA4AhzrIXhuDu7a+Any3pfC5As0mcL3O41iZqp/Rx1RHHtJHtPiWP2CQkYpUWmQ
         68B68HWhlcfOTaCurbpZWElWDl0SErWXRVb6y6EssuPMTeRyxYOkB9WQ/bkxZAKap4LI
         Beg5Qfeg5ocuZsA3oKoFMJo/HzXzQPFMkuVwF2i7JZg6Ujg0HIssjAwc1fqvKuCPjhNJ
         DifFhqjgnhf3iT36jNISIcN+cOXdkaojE8jCsTdTHaqS8PAwpJoDViUTkzkrjh3JORde
         x8O8Stoeezf/+APV8AQGsrxjDMJy23cnx008d92PV0XHm5K8tmd9KvS+XV2JfOTXtu0N
         z0Eg==
X-Gm-Message-State: APjAAAXKLZmk5RIJhFaSU/ufDfnspwwUSUMvnT7l6IZWPDeJYNpwzx05
        R3kOVCsfsQ+wFUO3yjtHXYg=
X-Google-Smtp-Source: APXvYqx2kc9JvLpidJVrqT+1TQgGqz8vlFg1J4FL0mY1SSRMvf8CASTEtbzobdFJ925xi9A+uJ3sLw==
X-Received: by 2002:a17:902:744c:: with SMTP id e12mr7870666plt.287.1562893263756;
        Thu, 11 Jul 2019 18:01:03 -0700 (PDT)
Received: from localhost ([220.240.228.224])
        by smtp.gmail.com with ESMTPSA id p20sm10592978pgj.47.2019.07.11.18.01.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 18:01:03 -0700 (PDT)
Date:   Fri, 12 Jul 2019 10:57:55 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: PPC: Ultravisor: Introduce the MSR_S bit
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     Michael Anderson <andmike@linux.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
        <20190628200825.31049-2-cclaudio@linux.ibm.com>
In-Reply-To: <20190628200825.31049-2-cclaudio@linux.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1562892336.boqkwvamhq.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho's on June 29, 2019 6:08 am:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>=20
> The ultravisor processor mode is introduced in POWER platforms that
> supports the Protected Execution Facility (PEF). Ultravisor is higher
> privileged than hypervisor mode.
>=20
> In PEF enabled platforms, the MSR_S bit is used to indicate if the
> thread is in secure state. With the MSR_S bit, the privilege state of
> the thread is now determined by MSR_S, MSR_HV and MSR_PR, as follows:
>=20
> S   HV  PR
> -----------------------
> 0   x   1   problem
> 1   0   1   problem
> x   x   0   privileged
> x   1   0   hypervisor
> 1   1   0   ultravisor
> 1   1   1   reserved

What does this table mean? I thought 'x' meant either, but in that
case there are several states that can apply to the same
combination of bits.

Would it be clearer to rearrange the table so the columns are the HV
and PR bits we know and love, plus the effect of S=3D1 on each of them?

      HV  PR  S=3D0         S=3D1
      ---------------------------------------------
      0   0   privileged  privileged (secure guest kernel)
      0   1   problem     problem (secure guest userspace)
      1   0   hypervisor  ultravisor
      1   1   problem     reserved

Is that accurate?


>=20
> The hypervisor doesn't (and can't) run with the MSR_S bit set, but a
> secure guest and the ultravisor firmware do.
>=20
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [ Update the commit message ]
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/reg.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/re=
g.h
> index 10caa145f98b..39b4c0a519f5 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -38,6 +38,7 @@
>  #define MSR_TM_LG	32		/* Trans Mem Available */
>  #define MSR_VEC_LG	25	        /* Enable AltiVec */
>  #define MSR_VSX_LG	23		/* Enable VSX */
> +#define MSR_S_LG	22		/* Secure VM bit */
>  #define MSR_POW_LG	18		/* Enable Power Management */
>  #define MSR_WE_LG	18		/* Wait State Enable */
>  #define MSR_TGPR_LG	17		/* TLB Update registers in use */
> @@ -71,11 +72,13 @@
>  #define MSR_SF		__MASK(MSR_SF_LG)	/* Enable 64 bit mode */
>  #define MSR_ISF		__MASK(MSR_ISF_LG)	/* Interrupt 64b mode valid on 630 *=
/
>  #define MSR_HV 		__MASK(MSR_HV_LG)	/* Hypervisor state */
> +#define MSR_S		__MASK(MSR_S_LG)	/* Secure state */

This is a real nitpick, but why two different comments for the bit=20
number and the mask?

=
