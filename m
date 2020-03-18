Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC5118A232
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Mar 2020 19:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCRSQs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 14:16:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:23602 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgCRSQr (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 18 Mar 2020 14:16:47 -0400
IronPort-SDR: Zr+RVKBorud0TjW/WLhYFAdylKrDc61sJr9Fc4lVn66zwEDB3nvaxXtE8+9ajpf9hQZBeP0yst
 OJJ5edEEJNCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 11:16:47 -0700
IronPort-SDR: /nMRDuFjDvnEQdAI25G2RprZu7vl2tFb/s5g9nSzTkbNQFEl6S1jB8R9gAAlxCI24lNdz7A8m0
 4//JGQe4hw+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="291388997"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Mar 2020 11:16:46 -0700
Date:   Wed, 18 Mar 2020 11:16:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/3] KVM: PPC: Fix kernel crash with PR KVM
Message-ID: <20200318181646.GL24357@linux.intel.com>
References: <158455340419.178873.11399595021669446372.stgit@bahia.lan>
 <158455341029.178873.15248663726399374882.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158455341029.178873.15248663726399374882.stgit@bahia.lan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Mar 18, 2020 at 06:43:30PM +0100, Greg Kurz wrote:
> It turns out that this is only relevant to PR KVM actually. And both
> 32 and 64 backends need vcpu->arch.book3s to be valid when calling
> kvmppc_mmu_destroy_pr(). So instead of calling kvmppc_mmu_destroy()
> from kvm_arch_vcpu_destroy(), call kvmppc_mmu_destroy_pr() at the
> beginning of kvmppc_core_vcpu_free_pr(). This is consistent with
> kvmppc_mmu_init() being the last call in kvmppc_core_vcpu_create_pr().
> 
> For the same reason, if kvmppc_core_vcpu_create_pr() returns an
> error then this means that kvmppc_mmu_init() was either not called
> or failed, in which case kvmppc_mmu_destroy() should not be called.
> Drop the line in the error path of kvm_arch_vcpu_create().
> 
> Fixes: ff030fdf5573 ("KVM: PPC: Move kvm_vcpu_init() invocation to common code")
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---

Dang, I see where I went wrong.  Sorry :-(

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
