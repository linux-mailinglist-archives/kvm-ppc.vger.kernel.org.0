Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D24A3541F4
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhDEMK0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 5 Apr 2021 08:10:26 -0400
Received: from pv50p00im-ztdg10021801.me.com ([17.58.6.56]:38431 "EHLO
        pv50p00im-ztdg10021801.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237067AbhDEMK0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 5 Apr 2021 08:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1617624619; bh=4fSfaShOhJJCs8r4i+cCU95K6pSP9J9eia0Ma5j4ZXA=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=M0QDyFixUUI1vvqOSaytNyewqEpDI4fk1J5j6+1937+h1ZgJ3MgdmCbQTO5ZRmMKW
         58lML7CGCWckEOQgE06AVJ2Tb3cmC9gjll1wuU0r+/eDK1u4pVAmFDxEb60aF8zDsz
         /kxxN37vSTGVfawFUbezLU2xG+yeSzuf92i1poFM+s+eIy0/7A1YqL9Gk3aj9GJu4G
         Fsxes4s5H5iGG7fdL+QHFyXUxetjiBrrAQZ/ZkWz/Cb0E1nZvUF+b9Q6kYIhmDs9bd
         pnK0Sn1/+inPOCACginlCtZohrKfPdCR4Ouq4PsatfdBzn6MbdrEbOevwMQyIfqdMa
         Ki6zix9NtBN7w==
Received: from 192.168.1.3 (unknown [120.245.2.39])
        by pv50p00im-ztdg10021801.me.com (Postfix) with ESMTPSA id 8DA52360261;
        Mon,  5 Apr 2021 12:10:11 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
From:   Xiongwei Song <sxwjean@me.com>
In-Reply-To: <1617262858.ls37f2d81f.astroid@bobo.none>
Date:   Mon, 5 Apr 2021 20:10:07 +0800
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Segher Boessenkool <segher@kernel.crashing.org>, aik@ozlabs.ru,
        akpm@linux-foundation.org, alistair@popple.id.au,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        benh@kernel.crashing.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        haren@linux.ibm.com, jniethe5@gmail.com, john.ogness@linutronix.de,
        kan.liang@linux.intel.com, kjain@linux.ibm.com,
        kvm-ppc@vger.kernel.org, leobras.c@gmail.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        maddy@linux.ibm.com, mikey@neuling.org, msuchanek@suse.de,
        oleg@redhat.com, paulus@samba.org, peterx@redhat.com,
        peterz@infradead.org, pmladek@suse.com,
        ravi.bangoria@linux.ibm.com, rppt@kernel.org,
        Xiongwei Song <sxwjean@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <F7115AE3-6147-4C4C-B80C-BD70BCFE6FC4@me.com>
References: <20210330150425.10145-1-sxwjean@me.com>
 <875z17y79i.fsf@mpe.ellerman.id.au>
 <20210331212550.GD13863@gate.crashing.org>
 <87im5620f3.fsf@mpe.ellerman.id.au> <1617262858.ls37f2d81f.astroid@bobo.none>
To:     Nicholas Piggin <npiggin@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_08:2021-04-01,2021-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2104050084
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Regards,
Xiongwei




> On Apr 1, 2021, at 4:01 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
> 
> Excerpts from Michael Ellerman's message of April 1, 2021 12:39 pm:
>> Segher Boessenkool <segher@kernel.crashing.org> writes:
>>> On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
>>>> So perhaps:
>>>> 
>>>>  EXC_SYSTEM_RESET
>>>>  EXC_MACHINE_CHECK
>>>>  EXC_DATA_STORAGE
>>>>  EXC_DATA_SEGMENT
>>>>  EXC_INST_STORAGE
>>>>  EXC_INST_SEGMENT
>>>>  EXC_EXTERNAL_INTERRUPT
>>>>  EXC_ALIGNMENT
>>>>  EXC_PROGRAM_CHECK
>>>>  EXC_FP_UNAVAILABLE
>>>>  EXC_DECREMENTER
>>>>  EXC_HV_DECREMENTER
>>>>  EXC_SYSTEM_CALL
>>>>  EXC_HV_DATA_STORAGE
>>>>  EXC_PERF_MONITOR
>>> 
>>> These are interrupt (vectors), not exceptions.  It doesn't matter all
>>> that much, but confusing things more isn't useful either!  There can be
>>> multiple exceptions that all can trigger the same interrupt.
>> 
>> Yeah I know, but I think that ship has already sailed as far as the
>> naming we have in the kernel.
> 
> It has, but there are also several other ships also sailing in different 
> directions. It could be worse though, at least they are not sideways in 
> the Suez.
> 
>> We have over 250 uses of "exc", and several files called "exception"
>> something.
>> 
>> Using "interrupt" can also be confusing because Linux uses that to mean
>> "external interrupt".
>> 
>> But I dunno, maybe INT or VEC is clearer? .. or TRAP :)
> 
> We actually already have defines that follow Segher's suggestion, it's 
> just that they're hidden away in a KVM header.
> 
> #define BOOK3S_INTERRUPT_SYSTEM_RESET   0x100
> #define BOOK3S_INTERRUPT_MACHINE_CHECK  0x200
> #define BOOK3S_INTERRUPT_DATA_STORAGE   0x300
> #define BOOK3S_INTERRUPT_DATA_SEGMENT   0x380
> #define BOOK3S_INTERRUPT_INST_STORAGE   0x400
> #define BOOK3S_INTERRUPT_INST_SEGMENT   0x480
> #define BOOK3S_INTERRUPT_EXTERNAL       0x500
> #define BOOK3S_INTERRUPT_EXTERNAL_HV    0x502
> #define BOOK3S_INTERRUPT_ALIGNMENT      0x600
> 
> It would take just a small amount of work to move these to general 
> powerpc header, add #ifdefs for Book E/S where the numbers differ,
> and remove the BOOK3S_ prefix.
> 
> I don't mind INTERRUPT_ but INT_ would be okay too. VEC_ actually
> doesn't match what Book E does (which is some weirdness to map some
> of them to match Book S but not all, arguably we should clean that
> up too and just use vector numbers consistently, but the INTERRUPT_
> prefix would still be valid if we did that).
> 
> BookE KVM entry will still continue to use a different convention
> there so I would leave all those KVM defines in place for now, we
> might do another pass on them later.

Thanks for the comments. 

> 
> Thanks,
> Nick

