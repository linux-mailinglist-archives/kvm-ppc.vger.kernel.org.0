Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC32BDDD4
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Sep 2019 14:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405053AbfIYMM2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 Sep 2019 08:12:28 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36927 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405211AbfIYMM2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 Sep 2019 08:12:28 -0400
Received: by mail-qt1-f194.google.com with SMTP id l3so1816113qtr.4
        for <kvm-ppc@vger.kernel.org>; Wed, 25 Sep 2019 05:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oBVGKXAk9w+4EA6L5BY1AZojVwuWJkNrQjSpnpyAGMs=;
        b=c4bcBKL2RswqhJka+wiljWOhLAsbSc3lO0LNNlKe115b8Vdcoi5KORR97rsw/4sSOZ
         oRYLiTAtgcDBybItrH5KMGkBJeced+LfN+XdUQgEPNbJCama9mP+oe4D8hi+7SPDFuHE
         cN82TlTIPwKRRekxBmeW9MnWTcxIeqIdQqcA6WzNm2IpDALCVibW9Snm7k84lsd9ivPD
         kr71R+AFyhKUTHoqANP8iHQV5/3ayDDQcz8FMJfnrdEZs2j/PHQcAI01jsAmgG3+gYqJ
         8lLbKM+F8DVS9fGj0vpB8i1g12PeVvmDTRT8DeG9r1p7l10fY3zXEkptqGmDnq5PBqsA
         HHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oBVGKXAk9w+4EA6L5BY1AZojVwuWJkNrQjSpnpyAGMs=;
        b=DpzQ5uJqjXz/0YTBggaWhOqg1qZ+yz35N/p88Hulgt/lZOoMnB8u/phIIdfeAaKE4e
         +2oZbvIZCQmuig8fOUoX76q1v3EwWQ/kImBhbzd23z0xoghDxGMefaFk8bPYHnjnzE8U
         Tng8cRlZl5bWN8uAVUXohsalPZ7kVIEW8vfhEFbzMuXCng1N7T8uwwkvnDsRBIAkZZbK
         rQBwcMz5Idki57U2X9GfsoAByMZrCUHjbtyvCvAQk59ZlHKLGc5JGI0d8sVngFYKcNur
         GZdCEFxX6YVfY2kux4KwMkpEz4aUxjpNK6M+lT45dbyFmO9RGJVAiZw3nsnEFpqQLB8Q
         tgQg==
X-Gm-Message-State: APjAAAUwusRHmysm1jBIjQs1+59wnLJNQpED1oaBpAIXuHal5jM/jJSR
        AM+c1yBU35HqLdqn1cy0ut8RDQ==
X-Google-Smtp-Source: APXvYqxA9x+bSDQm0nofvSyORE8/echJIVBjKRlR0e39o2pTT9Cm797abvqf7P+y0MOYdExlef7hMQ==
X-Received: by 2002:ac8:36bb:: with SMTP id a56mr8429682qtc.164.1569413547483;
        Wed, 25 Sep 2019 05:12:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-223-10.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.223.10])
        by smtp.gmail.com with ESMTPSA id u132sm2520827qka.50.2019.09.25.05.12.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Sep 2019 05:12:26 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iD69i-0006UQ-D3; Wed, 25 Sep 2019 09:12:26 -0300
Date:   Wed, 25 Sep 2019 09:12:26 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v9 2/8] KVM: PPC: Move pages between normal and secure
 memory
Message-ID: <20190925121226.GA21150@ziepe.ca>
References: <20190925050649.14926-1-bharata@linux.ibm.com>
 <20190925050649.14926-3-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925050649.14926-3-bharata@linux.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Sep 25, 2019 at 10:36:43AM +0530, Bharata B Rao wrote:
> Manage migration of pages betwen normal and secure memory of secure
> guest by implementing H_SVM_PAGE_IN and H_SVM_PAGE_OUT hcalls.
> 
> H_SVM_PAGE_IN: Move the content of a normal page to secure page
> H_SVM_PAGE_OUT: Move the content of a secure page to normal page
> 
> Private ZONE_DEVICE memory equal to the amount of secure memory
> available in the platform for running secure guests is created.
> Whenever a page belonging to the guest becomes secure, a page from
> this private device memory is used to represent and track that secure
> page on the HV side. The movement of pages between normal and secure
> memory is done via migrate_vma_pages() using UV_PAGE_IN and
> UV_PAGE_OUT ucalls.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
>  arch/powerpc/include/asm/hvcall.h           |   4 +
>  arch/powerpc/include/asm/kvm_book3s_uvmem.h |  29 ++
>  arch/powerpc/include/asm/kvm_host.h         |  13 +
>  arch/powerpc/include/asm/ultravisor-api.h   |   2 +
>  arch/powerpc/include/asm/ultravisor.h       |  14 +
>  arch/powerpc/kvm/Makefile                   |   3 +
>  arch/powerpc/kvm/book3s_hv.c                |  20 +
>  arch/powerpc/kvm/book3s_hv_uvmem.c          | 481 ++++++++++++++++++++
>  8 files changed, 566 insertions(+)
>  create mode 100644 arch/powerpc/include/asm/kvm_book3s_uvmem.h
>  create mode 100644 arch/powerpc/kvm/book3s_hv_uvmem.c
> 
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
> index 11112023e327..2595d0144958 100644
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -342,6 +342,10 @@
>  #define H_TLB_INVALIDATE	0xF808
>  #define H_COPY_TOFROM_GUEST	0xF80C
>  
> +/* Platform-specific hcalls used by the Ultravisor */
> +#define H_SVM_PAGE_IN		0xEF00
> +#define H_SVM_PAGE_OUT		0xEF04
> +
>  /* Values for 2nd argument to H_SET_MODE */
>  #define H_SET_MODE_RESOURCE_SET_CIABR		1
>  #define H_SET_MODE_RESOURCE_SET_DAWR		2
> diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
> new file mode 100644
> index 000000000000..9603c2b48d67
> +++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __POWERPC_KVM_PPC_HMM_H__
> +#define __POWERPC_KVM_PPC_HMM_H__

This is a strange sentinal for a header called kvm_book3s_uvmem.h

Jason
