Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECA9292AFD
	for <lists+kvm-ppc@lfdr.de>; Mon, 19 Oct 2020 18:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgJSQB2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 19 Oct 2020 12:01:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730335AbgJSQB2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 19 Oct 2020 12:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603123287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xnOeLfGLTUy5AgN8jhCNmXzK0dSH/7S/Ox3jrYuwhp4=;
        b=I6HjXtlpWgPSX8hTtf5gNI9pcpXQVpUe2Hur63mp0Wn4jtIGKkqdDKYS2OiIva0q+abal7
        iGJ/pLNMxEknUCMkqcNnVwwLPUAs3e8dYHqQD2wB0I2v8pH9gQUPYcVEWnlIGEJUSIzSHo
        Nw88paXUv0pfWxbrBkt+i3cStJpulDU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-CZ_0bkRDNm-x_ubngBri2w-1; Mon, 19 Oct 2020 12:01:18 -0400
X-MC-Unique: CZ_0bkRDNm-x_ubngBri2w-1
Received: by mail-wm1-f71.google.com with SMTP id c204so1792wmd.5
        for <kvm-ppc@vger.kernel.org>; Mon, 19 Oct 2020 09:01:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xnOeLfGLTUy5AgN8jhCNmXzK0dSH/7S/Ox3jrYuwhp4=;
        b=l7iX7TL+No1gDPrF86QP0/3pgIoZeKcrMoX9TXxxKSN7i4BjWBIpCKX17oDRXHXgpm
         jTMkihy5I5JQpQwYAmLcBw62r2InrTYKfcw3ZVIknYCFlZvvnvWbdJooJZCd8HtmLeO8
         kTRsyqqnvB0T3YFCjTucbKNAPnhlX0cMrQ1t+2qC2n9Tw4D3EP8Fe1S/xPjQ+IW7mWaQ
         OgppoRw/gv3dyXP4LO1XsyIFi3bi4FeeAZUuacNcItJcj61BdDsqovxuthF8pjqK+5U1
         WqvzQO0/MjOHj4ob2vRc1xm0bKVUwE7+ZNZyqqEzxod/dqIYUkyvOGBtLO81ZnehOsq8
         5l7g==
X-Gm-Message-State: AOAM530jqf5E503qggLcbOTb+bbM0Qehxf4iNLCU4keLBJubYaL3UuAp
        r47Ghd0KXmPbZr0derbtlyX+oUs1vliEvJJqfb1M7FKfn0dGBKTG5YadXV87w5c2oNSrLZ59wfU
        aOVYsFd/txJhgvUeTvQ==
X-Received: by 2002:adf:fa05:: with SMTP id m5mr245223wrr.57.1603123277243;
        Mon, 19 Oct 2020 09:01:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKxOu81uqDh+9uxrRSdxg88EvBO4mlL2AidEN3mjsJSrEou8SdfIvWp/NkY5z0pMi9CEOU/Q==
X-Received: by 2002:adf:fa05:: with SMTP id m5mr245196wrr.57.1603123277038;
        Mon, 19 Oct 2020 09:01:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x65sm55385wmg.1.2020.10.19.09.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 09:01:16 -0700 (PDT)
Subject: Re: [PATCH 1/4] KVM: PPC: Book3S HV: Make struct kernel_param_ops
 definition const
To:     Joe Perches <joe@perches.com>, Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Davidlohr Bueso <dave@stgolabs.net>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <cover.1601770305.git.joe@perches.com>
 <d130e88dd4c82a12d979da747cc0365c72c3ba15.1601770305.git.joe@perches.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e1945b90-c97c-f998-56b2-e5635992848a@redhat.com>
Date:   Mon, 19 Oct 2020 18:01:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <d130e88dd4c82a12d979da747cc0365c72c3ba15.1601770305.git.joe@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 04/10/20 02:18, Joe Perches wrote:
> This should be const, so make it so.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 4ba06a2a306c..2b215852cdc9 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -111,7 +111,7 @@ module_param(one_vm_per_core, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a core (requires indep_threads_mode=N)");
>  
>  #ifdef CONFIG_KVM_XICS
> -static struct kernel_param_ops module_param_ops = {
> +static const struct kernel_param_ops module_param_ops = {
>  	.set = param_set_int,
>  	.get = param_get_int,
>  };
> 

Queued, thanks.

Paolo

