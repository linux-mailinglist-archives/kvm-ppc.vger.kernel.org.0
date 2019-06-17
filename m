Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38EFC477DE
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 04:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfFQCGh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 16 Jun 2019 22:06:37 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40083 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbfFQCGh (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 16 Jun 2019 22:06:37 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45Rvhq1xMXz9sBr; Mon, 17 Jun 2019 12:06:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560737195; bh=oCQDQTZLySOsNpFkc0RCedPxkKTKkLOJdYTa6K/YZmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iKIkMtWu0qozAuAIchTQg8kWDplAc5IgvaAPRhr1iRDkdjkookK0pYnQkp85uADDD
         Y2ypCoFLvSzDpGtSBThmOLIr0hKojL2Z4NF85cdGBWMzANG+5wADlQmOr5uWZxe3Rn
         S7wMNbtE/9YKCaGH8e1eUywz3w81L3q2TAYm5zH4tvNEzf6fzhynrB+ZdN++e99h8Q
         cr1Z0M4ub9FtRmVF1TLeKadxukW2lE7dENSGzFjc0uNdLp2NweSSeQPE5e0oR+ZjD9
         Je9Jq5uKOgK+E6fHoSEZ5AJdCyvkNBL8wujL8iLvQ8uVbgo3l1rG24qfVtqehAKPk6
         pZsfYv8Nk9sgA==
Date:   Mon, 17 Jun 2019 12:06:32 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 4/9] KVM: PPC: Ultravisor: Add generic ultravisor call
 handler
Message-ID: <20190617020632.yywfoqwfinjxs3pb@oak.ozlabs.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-5-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606173614.32090-5-cclaudio@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:09PM -0300, Claudio Carvalho wrote:
> From: Ram Pai <linuxram@us.ibm.com>
> 
> Add the ucall() function, which can be used to make ultravisor calls
> with varied number of in and out arguments. Ultravisor calls can be made
> from the host or guests.
> 
> This copies the implementation of plpar_hcall().

One point which I missed when I looked at this patch previously is
that the ABI that we're defining here is different from the hcall ABI
in that we are putting the ucall number in r0, whereas hcalls have the
hcall number in r3.  That makes ucalls more like syscalls, which have
the syscall number in r0.  So that last sentence quoted above is
somewhat misleading.

The thing we need to consider is that when SMFCTRL[E] = 0, a ucall
instruction becomes a hcall (that is, sc 2 is executed as if it was
sc 1).  In that case, the first argument to the ucall will be
interpreted as the hcall number.  Mostly that will happen not to be a
valid hcall number, but sometimes it might unavoidably be a valid but
unintended hcall number.

I think that will make it difficult to get ucalls to fail gracefully
in the case where SMF/PEF is disabled.  It seems like the assignment
of ucall numbers was made so that they wouldn't overlap with valid
hcall numbers; presumably that was so that we could tell when an hcall
was actually intended to be a ucall.  However, using a different GPR
to pass the ucall number defeats that.

I realize that there is ultravisor code in development that takes the
ucall number in r0, and also that having the ucall number in r3 would
possibly make life more difficult for the place where we call
UV_RETURN in assembler code.  Nevertheless, perhaps we should consider
changing the ABI to be like the hcall ABI before everything gets set
in concrete.

Paul.
