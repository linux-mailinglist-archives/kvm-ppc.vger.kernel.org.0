Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0586449F8E
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Jun 2019 13:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfFRLrP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jun 2019 07:47:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:48959 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729110AbfFRLrP (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 18 Jun 2019 07:47:15 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x5IBl3PL028615;
        Tue, 18 Jun 2019 06:47:03 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id x5IBl1Zl028614;
        Tue, 18 Jun 2019 06:47:01 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Tue, 18 Jun 2019 06:47:01 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Claudio Carvalho <cclaudio@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@ozlabs.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 4/9] KVM: PPC: Ultravisor: Add generic ultravisor call handler
Message-ID: <20190618114701.GH7313@gate.crashing.org>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com> <20190606173614.32090-5-cclaudio@linux.ibm.com> <20190617020632.yywfoqwfinjxs3pb@oak.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617020632.yywfoqwfinjxs3pb@oak.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Paul,

On Mon, Jun 17, 2019 at 12:06:32PM +1000, Paul Mackerras wrote:
> The thing we need to consider is that when SMFCTRL[E] = 0, a ucall
> instruction becomes a hcall (that is, sc 2 is executed as if it was
> sc 1).  In that case, the first argument to the ucall will be
> interpreted as the hcall number.  Mostly that will happen not to be a
> valid hcall number, but sometimes it might unavoidably be a valid but
> unintended hcall number.

Shouldn't a caller of the ultravisor *know* that it is talking to the
ultravisor in the first place?  And not to the hypervisor.


Segher
