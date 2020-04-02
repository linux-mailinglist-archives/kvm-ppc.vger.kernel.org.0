Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADE319BA9C
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Apr 2020 05:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgDBDOZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Apr 2020 23:14:25 -0400
Received: from floodgap.com ([66.166.122.164]:54675 "EHLO floodgap.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732498AbgDBDOZ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 1 Apr 2020 23:14:25 -0400
Received: (from spectre@localhost)
        by floodgap.com (6.6.6.666.1/2015.03.25) id 0323EJ3d29163726;
        Wed, 1 Apr 2020 20:14:19 -0700
From:   Cameron Kaiser <spectre@floodgap.com>
Message-Id: <202004020314.0323EJ3d29163726@floodgap.com>
Subject: Re: crash unloading kvm_hv
In-Reply-To: <20200401052129.GA5599@blackberry> from Paul Mackerras at "Apr 1, 20 04:21:29 pm"
To:     paulus@ozlabs.org (Paul Mackerras)
Date:   Wed, 1 Apr 2020 20:14:19 -0700 (PDT)
Cc:     spectre@floodgap.com, kvm-ppc@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL39 (25)]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> > HPT kernel. When removing the kvm_hv module, the kernel goes bananas. Any
> > ideas? I had to hard-power-down the machine to get control. I don't have a
> > regression range for this.
[...]
> > # modprobe -r kvm_hv
> > (system becomes unstable)
> > 
> > Backtrace and dmesg:
> > 
> > BUG: Kernel NULL pointer dereference on read at 0x00000008
> > Faulting instruction address: 0xc00000000088a114
> > Oops: Kernel access of bad area, sig: 11 [#1]

> You have kvmppc_uvmem_free in the backtrace.  You probably need either
> to apply http://patchwork.ozlabs.org/patch/1258499/ "KVM: PPC: Book3S
> HV: Skip kvmppc_uvmem_free if Ultravisor is not supported" or else
> turn off CONFIG_PPC_UV.

Odd, I didn't expect that Fedora 31 would have it on (this is a stock
kernel). Thanks for the pointer.

-- 
------------------------------------ personal: http://www.cameronkaiser.com/ --
  Cameron Kaiser * Floodgap Systems * www.floodgap.com * ckaiser@floodgap.com
-- #include <std_disclaimer.h> ------------------------------------------------
