Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE26A22C3A
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 08:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfETGl3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 May 2019 02:41:29 -0400
Received: from ozlabs.org ([203.11.71.1]:35125 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbfETGl2 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 20 May 2019 02:41:28 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 456q6t54mdz9s9N; Mon, 20 May 2019 16:41:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558334486; bh=QEuNNwxQBX41d0QJRz4odHqyh4NW3Ru3samHQRyhn0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bBJ0iHd3/nTI8DR4svY+hZf7RDgH3Tzy0Ww33EomKBSwWbs4XjXP1f6ijK3PrKUPH
         pZfcEuJkvw0BDQEmco8CYR2SHhWVAdpbYl7G+XCDyYJxplq5sBeHOmOXEnRlY/qS+e
         SmmDqNZ68THRzsoreo4nWUXUC+MwNCrtHlxI2/VilcjTMQt/Hwcg9xi7Hbk9m7UiEi
         Zjs+OSmtWoElgbaDDrqEw+M0H5YncGBs0AkOTTMAJnkIxKsf+6s8xvxy8PMOZnA1lA
         yGuONvY4nBSHaA3222J7h9dvetMvZhJw/obXydl9ofW80MYWIsaaFrYh0Q58HCRCkS
         CDopIqWSk3yww==
Date:   Mon, 20 May 2019 16:40:23 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ram Pai <linuxram@us.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: Re: [RFC PATCH v2 09/10] KVM: PPC: Book3S HV: Fixed for running
 secure guests
Message-ID: <20190520064023.GD21382@blackberry>
References: <20190518142524.28528-1-cclaudio@linux.ibm.com>
 <20190518142524.28528-10-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190518142524.28528-10-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 18, 2019 at 11:25:23AM -0300, Claudio Carvalho wrote:
> From: Paul Mackerras <paulus@ozlabs.org>
> 
> - Pass SRR1 in r11 for UV_RETURN because SRR0 and SRR1 get set by
>   the sc 2 instruction. (Note r3 - r10 potentially have hcall return
>   values in them.)
> 
> - Fix kvmppc_msr_interrupt to preserve the MSR_S bit.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

This should be folded into the previous patch.

Paul.
