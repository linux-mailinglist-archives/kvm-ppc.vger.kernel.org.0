Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4CEF0E90
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 06:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfKFF6a (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 00:58:30 -0500
Received: from ozlabs.org ([203.11.71.1]:54353 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727568AbfKFF63 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 477G6q5JGMz9sQy; Wed,  6 Nov 2019 16:58:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573019907; bh=uxD2BTixjqrm1dB6sKzow9x5pztHfF4238phxQ8BQKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ciR7ncEPNUOWorVTvgXfESPYNSN7jm+1hXyZWGYwgCOVWVQAABvrmxGJUn0lbFxDO
         kRCHi3iRYKvCe6p/C/hmqZBxW7DyTHoAm94WB/4Z8HUIZV9QbLREGsRRq7GhHEWSDg
         maJv1xzn7cjVJve4Saz0lG7qwhpQHoIsgfO/zeOMdnTMqHhK35t1XLMHIRBk7Piokg
         zGzMC1UassrHrRfJp5dIOnh+EuF29AMcsfuALIWUtpOoODRhy5dzCRpJXofdQvpGmq
         KlAPYgunlyi9E6Po8S39aVXpIHpnRcNHlZqSZWAGgbql8jWCifdZCPNex+5ybe9I4d
         hIYmpQty8wLCQ==
Date:   Wed, 6 Nov 2019 15:34:57 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 2/8] KVM: PPC: Support for running secure guests
Message-ID: <20191106043457.GC12069@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-3-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-3-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:54AM +0530, Bharata B Rao wrote:
> A pseries guest can be run as secure guest on Ultravisor-enabled
> POWER platforms. On such platforms, this driver will be used to manage
> the movement of guest pages between the normal memory managed by
> hypervisor (HV) and secure memory managed by Ultravisor (UV).
> 
> HV is informed about the guest's transition to secure mode via hcalls:
> 
> H_SVM_INIT_START: Initiate securing a VM
> H_SVM_INIT_DONE: Conclude securing a VM
> 
> As part of H_SVM_INIT_START, register all existing memslots with
> the UV. H_SVM_INIT_DONE call by UV informs HV that transition of
> the guest to secure mode is complete.
> 
> These two states (transition to secure mode STARTED and transition
> to secure mode COMPLETED) are recorded in kvm->arch.secure_guest.
> Setting these states will cause the assembly code that enters the
> guest to call the UV_RETURN ucall instead of trying to enter the
> guest directly.
> 
> Migration of pages betwen normal and secure memory of secure
> guest is implemented in H_SVM_PAGE_IN and H_SVM_PAGE_OUT hcalls.
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

Reviewed-by: Paul Mackerras <paulus@ozlabs.org>
