Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6172A46ECF
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 Jun 2019 09:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfFOHrt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 15 Jun 2019 03:47:49 -0400
Received: from ozlabs.org ([203.11.71.1]:37353 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfFOHrs (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 15 Jun 2019 03:47:48 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45QqMQ6mFsz9sNC; Sat, 15 Jun 2019 17:47:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560584866; bh=U4SYbjz4U+6Wsqkyzvs7txI2fXrHWgxLLSwdp3uAUTI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cckdYsiEtfS4WN8bppW3NlL6eJH69EywRLSCJ5KMan3Z3pHuSmyo+JjWnmhg4lyaM
         R2vIPIE1/4U5x5OyxofQVayM8j1QtjNMYYRhGu5aXdF2FCpfnhv9iTROBnZATJ56Tf
         H5/fqg72ZcyM0944GSxv3aedZXpRIruvd/bdWsOuIj1psUVFIDlIlt5Wtp7ndZveUM
         8h+siEnzz5E9/IIZQMXyg6nPOVbP10V9jeOpvN2zmeNcT+5N7GvtNMXUQulXjfG+iM
         jNvibLS5NDR/Qv5ITGNx8wCzX6OMTw1jEkqfpsRWqNvHgmGmGgVW5qw1KKn7Tqhpou
         wDgL9Qg2/bo3w==
Date:   Sat, 15 Jun 2019 17:45:50 +1000
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
Subject: Re: [PATCH v3 8/9] KVM: PPC: Ultravisor: Enter a secure guest
Message-ID: <20190615074550.GE24709@blackberry>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-9-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606173614.32090-9-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:13PM -0300, Claudio Carvalho wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> To enter a secure guest, we have to go through the ultravisor, therefore
> we do a ucall when we are entering a secure guest.
> 
> This change is needed for any sort of entry to the secure guest from the
> hypervisor, whether it is a return from an hcall, a return from a
> hypervisor interrupt, or the first time that a secure guest vCPU is run.
> 
> If we are returning from an hcall, the results are already in the
> appropriate registers (R3:12), except for R6,7, which need to be
> restored before doing the ucall (UV_RETURN).
> 
> Have fast_guest_return check the kvm_arch.secure_guest field so that a
> new CPU enters UV when started (in response to a RTAS start-cpu call).
> 
> Thanks to input from Paul Mackerras, Ram Pai and Mike Anderson.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> [Pass SRR1 in r11 for UV_RETURN, fix kvmppc_msr_interrupt to preserve
>  the MSR_S bit]
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> [Fix UV_RETURN token number and arch.secure_guest check]
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [Update commit message and ret_to_ultra comment]
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>

Paul.
