Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7649718C3BE
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 00:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgCSXeq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 19:34:46 -0400
Received: from ozlabs.org ([203.11.71.1]:36501 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgCSXeq (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 19 Mar 2020 19:34:46 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48k3Cl752Bz9sRN; Fri, 20 Mar 2020 10:34:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1584660884; bh=qqarS8RUzT5oByS0Dv5M1W/QDT2JjnNGafGudwfpqIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqGPQQT9hIicpkVTP8U8355GLkIl4mNolvydHn0A/7Bq7vdrx8V6QNNhkfh09sNlw
         9e8UPQ9PZU+AxXW7dsKJwHyNfEqtATzW7QYlYb5AlcEhqPBG13yYmVbSVDE0Zy0WxT
         ixc6wLKEYXDxBC4Il5h55tcHE79hBm7be4azj3iUheP16bayLZCAL8Had7cTbIUZ6V
         MULEOOmZ+opqH2QdWV0EkvhIeztyyozOgpHRrdM5cfIDWWVF+8XlH/G9+l4RUhC+8S
         o15F3BA6XRKpYatCW6lMBWpYZRSQD7kpnIXshWH1UTE+JdORyQWnoYS/DCXLxGyp73
         OUosK1yxCMedg==
Date:   Fri, 20 Mar 2020 10:32:56 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Michael Roth <mdroth@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix H_CEDE return code for nested
 guests
Message-ID: <20200319233256.GD3260@blackberry>
References: <20200310211128.17672-1-mdroth@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310211128.17672-1-mdroth@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 10, 2020 at 04:11:28PM -0500, Michael Roth wrote:
> The h_cede_tm kvm-unit-test currently fails when run inside an L1 guest
> via the guest/nested hypervisor.
> 
>   ./run-tests.sh -v
>   ...
>   TESTNAME=h_cede_tm TIMEOUT=90s ACCEL= ./powerpc/run powerpc/tm.elf -smp 2,threads=2 -machine cap-htm=on -append "h_cede_tm"
>   FAIL h_cede_tm (2 tests, 1 unexpected failures)
> 
> While the test relates to transactional memory instructions, the actual
> failure is due to the return code of the H_CEDE hypercall, which is
> reported as 224 instead of 0. This happens even when no TM instructions
> are issued.
> 
> 224 is the value placed in r3 to execute a hypercall for H_CEDE, and r3
> is where the caller expects the return code to be placed upon return.
> 
> In the case of guest running under a nested hypervisor, issuing H_CEDE
> causes a return from H_ENTER_NESTED. In this case H_CEDE is
> specially-handled immediately rather than later in
> kvmppc_pseries_do_hcall() as with most other hcalls, but we forget to
> set the return code for the caller, hence why kvm-unit-test sees the
> 224 return code and reports an error.
> 
> Guest kernels generally don't check the return value of H_CEDE, so
> that likely explains why this hasn't caused issues outside of
> kvm-unit-tests so far.
> 
> Fix this by setting r3 to 0 after we finish processing the H_CEDE.
> 
> RHBZ: 1778556
> 
> Fixes: 4bad77799fed ("KVM: PPC: Book3S HV: Handle hypercalls correctly when nested")
> Cc: linuxppc-dev@ozlabs.org
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Michael Roth <mdroth@linux.vnet.ibm.com>

Thanks, applied to my kvm-ppc-next branch.

Paul.
