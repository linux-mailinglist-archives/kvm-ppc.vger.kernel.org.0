Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3D5F0E8C
	for <lists+kvm-ppc@lfdr.de>; Wed,  6 Nov 2019 06:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfKFF63 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:54929 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfKFF63 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 6 Nov 2019 00:58:29 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 477G6q0k0vz9sPF; Wed,  6 Nov 2019 16:58:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573019907; bh=56y9/gEaDzQmeKp9iXKr2ut32/omIfnBdtSxBPQKzkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YSGwBlFfFtQL4eL2wF4UIeyChrpdMx5L4IUbxmr/LjnZOVz2ZGoNtyB+yYlJ6NtA2
         BeiWR2+BwJtRlAFJrHh8lmPqOVgoYHtG0PfPjtM+e0PeWvuqkDpPGr/usj1GDyfEfe
         v1g/aAkoeln+bBZwG8gP542+NfUDHOPkANX9UwdtqbLw+Qk7muJ+fjhgRTTIashezE
         YasQaF3hsR+LdzQHDsUrLk2WFEphkX6v8Sl/K5HoygKmAeqgteBfTNiOwlS/jcYEcs
         yBeX2BAOvFfASn2EVcrYBWyqM7kW5RvCdTgYnw6cxkN0oc4oBVajsfezPoNdhnmrbm
         SJqhWdJMjCEZw==
Date:   Wed, 6 Nov 2019 15:30:58 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 0/8] KVM: PPC: Driver to manage pages of secure guest
Message-ID: <20191106043058.GA12069@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-1-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:52AM +0530, Bharata B Rao wrote:
> Hi,
> 
> This is the next version of the patchset that adds required support
> in the KVM hypervisor to run secure guests on PEF-enabled POWER platforms.
> 
> The major change in this version is about not using kvm.arch->rmap[]
> array to store device PFNs, thus not depending on the memslot availability
> to reach to the device PFN from the fault path. Instead of rmap[], we
> now have a different array which gets created and destroyed along with
> memslot creation and deletion. These arrays hang off from kvm.arch and
> are arragned in a simple linked list for now. We could move to some other
> data structure in future if walking of linked list becomes an overhead
> due to large number of memslots.

Thanks.  This is looking really close now.

> Other changes include:
> 
> - Rearranged/Merged/Cleaned up patches, removed all Acks/Reviewed-by since
>   all the patches have changed.
> - Added a new patch to support H_SVM_INIT_ABORT hcall (From Suka)
> - Added KSM unmerge support so that VMAs that have device PFNs don't
>   participate in KSM merging and eventually crash in KSM code.
> - Release device pages during unplug (Paul) and ensure that memory
>   hotplug and unplug works correctly.
> - Let kvm-hv module to load on PEF-disabled platforms (Ram) when
>   CONFIG_PPC_UV is enabled allowing regular non-secure guests
>   to still run.
> - Support guest reset when swithing to secure is in progress.
> - Check if page is already secure in kvmppc_send_page_to_uv() before
>   sending it to UV.
> - Fixed sentinal for header file kvm_book3s_uvmem.h (Jason)
> 
> Now, all the dependencies required by this patchset are in powerpc/next
> on which this patchset is based upon.

Can you tell me what patches that are in powerpc/next but not upstream
this depends on?

Paul.
