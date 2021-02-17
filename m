Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E21B31DFAF
	for <lists+kvm-ppc@lfdr.de>; Wed, 17 Feb 2021 20:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhBQTdd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 17 Feb 2021 14:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbhBQTdc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 17 Feb 2021 14:33:32 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9164C061574
        for <kvm-ppc@vger.kernel.org>; Wed, 17 Feb 2021 11:32:51 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id c3so13324439qkj.11
        for <kvm-ppc@vger.kernel.org>; Wed, 17 Feb 2021 11:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=TRLf1G8f2Go1VE645xdlH8BG2DStOsSzPhXA0pRDJR4=;
        b=kRNTVaudWjexbvvommo9ZCKBIqaSKiymVPnn7WIbKB7wtdSdXFkRmnOk5llZOoym5H
         poqHg2pyNXl07F6LJTgvspwqzS8uFVcvxFumlosxKZmIngh5l6Ik5TC5U1SYq0KhOCR8
         43+cGVU+ZkH3pdyDaVjSkGydOtve2FLlX03pjBrqIeonhg3tVGWhG0h6kESokx0+Ggnb
         SvGTmWEpmrClGZj89P5kWK4/4FiOspRDyZcq7gzfmEqEjo9kYCwBd7ZRRonuCCmSHuAZ
         iInnIbyxgSg6j7fs2RArx5iZvt6IDyt/WXP3NOc9O26UaS4UTchYt/kZ1BmZXriYyWYq
         TwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=TRLf1G8f2Go1VE645xdlH8BG2DStOsSzPhXA0pRDJR4=;
        b=JONQoL0WOFX3oJjQ7RFg9a1Hj41D5IyFQhWGLMGIVRuP3/CfO8oykTG9U8+en3IP5Y
         h8anynxNX1MKk0T2GLUZcvyTF2Lm3VhiSJwQ5S1jHkIHggq/FVnMrQYaQUQ3mAodTQSl
         Dz9O9+KDKc2quE7jRLU5w3YjBzFYJb6ahABhsegYPLqNBD6Lxqf/FxnOag5cMS5B1NSB
         jNulB400LGukzmi0fx4vt9YtSrRwHb9+7nk7RXEm3shNijQ1Uzuz1Preio9tHqiAgG6j
         g8varyF50Xjeg1z3OQuWzewLrLxLXaGktz6K9Q27dQ7Qp7j+/Unhg8kCDHaueONqHn7x
         gaGw==
X-Gm-Message-State: AOAM533WobBsWE/5TzQ7DLMQKaFoDZp3o24bJwbB17n5oxnyPnmx8jn3
        wdaGw5203USIXyjxzlfifk7wEAkgEOo=
X-Google-Smtp-Source: ABdhPJzkR0AEx/9kpX4bJfW097t4PrjwjMgeaNwZpP8gKyBd/1UPcooKJA9XkH/8zFt8KFxkCEWTIA==
X-Received: by 2002:a37:a395:: with SMTP id m143mr739218qke.439.1613590370927;
        Wed, 17 Feb 2021 11:32:50 -0800 (PST)
Received: from li-908e0a4c-2250-11b2-a85c-f027e903211b.ibm.com (177-131-90-207.dynamic.desktop.com.br. [177.131.90.207])
        by smtp.gmail.com with ESMTPSA id u20sm1914972qtb.63.2021.02.17.11.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 11:32:50 -0800 (PST)
Message-ID: <433396d9ef216aa090e32bb344d42f60de1fb9aa.camel@gmail.com>
Subject: Re: [PATCH kernel 2/2] powerpc/iommu: Do not immediately panic when
 failed IOMMU table allocation
From:   Leonardo Bras <leobras.c@gmail.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Date:   Wed, 17 Feb 2021 16:32:45 -0300
In-Reply-To: <20210216033307.69863-3-aik@ozlabs.ru>
References: <20210216033307.69863-1-aik@ozlabs.ru>
         <20210216033307.69863-3-aik@ozlabs.ru>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 2021-02-16 at 14:33 +1100, Alexey Kardashevskiy wrote:
> Most platforms allocate IOMMU table structures (specifically it_map)
> at the boot time and when this fails - it is a valid reason for panic().
> 
> However the powernv platform allocates it_map after a device is returned
> to the host OS after being passed through and this happens long after
> the host OS booted. It is quite possible to trigger the it_map allocation
> panic() and kill the host even though it is not necessary - the host OS
> can still use the DMA bypass mode (requires a tiny fraction of it_map's
> memory) and even if that fails, the host OS is runnnable as it was without
> the device for which allocating it_map causes the panic.
> 
> Instead of immediately crashing in a powernv/ioda2 system, this prints
> an error and continues. All other platforms still call panic().
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Hello Alexey,

This looks like a good change, that passes panic() decision to platform
code. Everything looks pretty straightforward, but I have a question
regarding this:

> @@ -1930,16 +1931,16 @@ static long pnv_pci_ioda2_setup_default_config(struct pnv_ioda_pe *pe)
>  		res_start = pe->phb->ioda.m32_pci_base >> tbl->it_page_shift;
>  		res_end = min(window_size, SZ_4G) >> tbl->it_page_shift;
>  	}
> -	iommu_init_table(tbl, pe->phb->hose->node, res_start, res_end);
> -	rc = pnv_pci_ioda2_set_window(&pe->table_group, 0, tbl);
> 
> +	if (iommu_init_table(tbl, pe->phb->hose->node, res_start, res_end))
> +		rc = pnv_pci_ioda2_set_window(&pe->table_group, 0, tbl);
> +	else
> +		rc = -ENOMEM;
>  	if (rc) {
> -		pe_err(pe, "Failed to configure 32-bit TCE table, err %ld\n",
> -				rc);
> +		pe_err(pe, "Failed to configure 32-bit TCE table, err %ld\n", rc);
>  		iommu_tce_table_put(tbl);
> -		return rc;
> +		tbl = NULL; /* This clears iommu_table_base below */
>  	}
> -
>  	if (!pnv_iommu_bypass_disabled)
>  		pnv_pci_ioda2_set_bypass(pe, true);
>  
> 

If I could understand correctly, previously if iommu_init_table() did
not panic(), and pnv_pci_ioda2_set_window() returned something other
than 0, it would return rc in the if (rc) clause, but now it does not
happen anymore, going through if (!pnv_iommu_bypass_disabled) onwards.

Is that desired?

As far as I could see, returning rc there seems a good procedure after
iommu_init_table returning -ENOMEM.

Best regards, 
Leonardo Bras  




