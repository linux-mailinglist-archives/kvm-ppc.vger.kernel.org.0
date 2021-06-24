Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3929E3B309B
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 15:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFXOCP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 10:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOCO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 10:02:14 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6DAC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Jun 2021 06:59:55 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4G9hbD1RGfz9sVm; Thu, 24 Jun 2021 23:59:52 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Cc:     david@gibson.dropbear.id.au, farosas@linux.ibm.com,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com
In-Reply-To: <20210621085003.904767-1-bharata@linux.ibm.com>
References: <20210621085003.904767-1-bharata@linux.ibm.com>
Subject: Re: [PATCH v8 0/6] Support for H_RPT_INVALIDATE in PowerPC KVM
Message-Id: <162454315792.2927609.10468593686064082281.b4-ty@ellerman.id.au>
Date:   Thu, 24 Jun 2021 23:59:17 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 21 Jun 2021 14:19:57 +0530, Bharata B Rao wrote:
> This patchset adds support for the new hcall H_RPT_INVALIDATE
> and replaces the nested tlb flush calls with this new hcall
> if support for the same exists.
> 
> Changes in v8:
> -------------
> - Used tlb_single_page_flush_ceiling in the process-scoped range
>   flush routine to switch to full PID invalation if
>   the number of pages is above the threshold
> - Moved iterating over page sizes into the actual routine that
>   handles the eventual flushing thereby limiting the page size
>   iteration only to range based flushing
> - Converted #if 0 section into a comment section to avoid
>   checkpatch from complaining.
> - Used a threshold in the partition-scoped range flushing
>   to switch to full LPID invalidation
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/6] KVM: PPC: Book3S HV: Fix comments of H_RPT_INVALIDATE arguments
      https://git.kernel.org/powerpc/c/f09216a190a4c2f62e1725f9d92e7c122b4ee423
[2/6] powerpc/book3s64/radix: Add H_RPT_INVALIDATE pgsize encodings to mmu_psize_def
      https://git.kernel.org/powerpc/c/d6265cb33b710789cbc390316eba50a883d6dcc8
[3/6] KVM: PPC: Book3S HV: Add support for H_RPT_INVALIDATE
      https://git.kernel.org/powerpc/c/f0c6fbbb90504fb7e9dbf0865463d3c2b4de49e5
[4/6] KVM: PPC: Book3S HV: Nested support in H_RPT_INVALIDATE
      https://git.kernel.org/powerpc/c/53324b51c5eee22d420a2df68b1820d929fa90f3
[5/6] KVM: PPC: Book3S HV: Add KVM_CAP_PPC_RPT_INVALIDATE capability
      https://git.kernel.org/powerpc/c/b87cc116c7e1bc62a84d8c46acd401db179edb11
[6/6] KVM: PPC: Book3S HV: Use H_RPT_INVALIDATE in nested KVM
      https://git.kernel.org/powerpc/c/81468083f3c76a08183813e3af63a7c3cea3f537

cheers
