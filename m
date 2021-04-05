Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DF23541FE
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 14:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237126AbhDEMSw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 5 Apr 2021 08:18:52 -0400
Received: from pv50p00im-zteg10011501.me.com ([17.58.6.42]:37746 "EHLO
        pv50p00im-zteg10011501.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232630AbhDEMSv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 5 Apr 2021 08:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1617625124; bh=QsStWq6mD9+iZC30NgGbV07VlDxPOrDBY22BgrXLMhA=;
        h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
        b=niFvPSM9WQ3AkQBo+m2kzgdYAaClKmRbR3tNLS8tZBw/eBFHzldXQE7GZQa+OPKnk
         HL+KFLZ/1bYRJLMYZ8KW1Yni3Q2kagq6JkSXnLGYzvWV7rFqiAdrziDj/D2XYHOTz+
         oF7ZCFja9S5702cJRiFlQnSIZS3CsFj4670a2BC8KKtoHYkNRfAapRxerKsmJz9wTR
         S6C/qyuEnEukBLWxcL7Wl0T3etIiAad86tZXqjsPYpzKFVzlb+qfMbtxGdUAc+eg+Y
         DR8s3th3QB5j6EzkvlmXDywA1or2G1FNeXwglYqUnYdRpgif3ARkTyN32PF62mPxvP
         +2alHkzSJX4Jw==
Received: from 192.168.1.3 (unknown [120.245.2.39])
        by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id EEE36B0042C;
        Mon,  5 Apr 2021 12:18:36 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
From:   Xiongwei Song <sxwjean@me.com>
In-Reply-To: <1617322416.z3cicnpfxy.astroid@bobo.none>
Date:   Mon, 5 Apr 2021 20:18:33 +0800
Cc:     Segher Boessenkool <segher@kernel.crashing.org>,
        Xiongwei Song <sxwjean@gmail.com>, aik@ozlabs.ru,
        akpm@linux-foundation.org, alistair@popple.id.au,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        benh@kernel.crashing.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        haren@linux.ibm.com, jniethe5@gmail.com, john.ogness@linutronix.de,
        kan.liang@linux.intel.com, kjain@linux.ibm.com,
        kvm-ppc@vger.kernel.org, leobras.c@gmail.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        maddy@linux.ibm.com, mikey@neuling.org,
        Michael Ellerman <mpe@ellerman.id.au>, msuchanek@suse.de,
        oleg@redhat.com, paulus@samba.org, peterx@redhat.com,
        peterz@infradead.org, pmladek@suse.com,
        ravi.bangoria@linux.ibm.com, rppt@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D593E96B-7C86-4575-A724-EEC5F8536432@me.com>
References: <20210330150425.10145-1-sxwjean@me.com>
 <875z17y79i.fsf@mpe.ellerman.id.au>
 <20210331212550.GD13863@gate.crashing.org>
 <CAEVVKH8XDiEGHjXj6sJAHynhwqKWpNqj_Ws03AqwNjR8OmHf5w@mail.gmail.com>
 <20210401161131.GE13863@gate.crashing.org>
 <1617322416.z3cicnpfxy.astroid@bobo.none>
To:     Nicholas Piggin <npiggin@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_08:2021-04-01,2021-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=886 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2104050084
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Regards,
Xiongwei




> On Apr 2, 2021, at 8:36 AM, Nicholas Piggin <npiggin@gmail.com> wrote:
>=20
> Excerpts from Segher Boessenkool's message of April 2, 2021 2:11 am:
>> On Thu, Apr 01, 2021 at 10:55:58AM +0800, Xiongwei Song wrote:
>>> Segher Boessenkool <segher@kernel.crashing.org> =
=E4=BA=8E2021=E5=B9=B44=E6=9C=881=E6=97=A5=E5=91=A8=E5=9B=9B =
=E4=B8=8A=E5=8D=886:15=E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>> On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
>>>>> So perhaps:
>>>>>=20
>>>>>  EXC_SYSTEM_RESET
>>>>>  EXC_MACHINE_CHECK
>>>>>  EXC_DATA_STORAGE
>>>>>  EXC_DATA_SEGMENT
>>>>>  EXC_INST_STORAGE
>>>>>  EXC_INST_SEGMENT
>>>>>  EXC_EXTERNAL_INTERRUPT
>>>>>  EXC_ALIGNMENT
>>>>>  EXC_PROGRAM_CHECK
>>>>>  EXC_FP_UNAVAILABLE
>>>>>  EXC_DECREMENTER
>>>>>  EXC_HV_DECREMENTER
>>>>>  EXC_SYSTEM_CALL
>>>>>  EXC_HV_DATA_STORAGE
>>>>>  EXC_PERF_MONITOR
>>>>=20
>>>> These are interrupt (vectors), not exceptions.  It doesn't matter =
all
>>>> that much, but confusing things more isn't useful either!  There =
can be
>>>> multiple exceptions that all can trigger the same interrupt.
>>>>=20
>>>> When looking at the reference manual of e500 and e600 from NXP
>>> official, they call them as interrupts.While looking at the "The
>>> Programming Environments"
>>> that is also from NXP, they call them exceptions. Looks like there =
is
>>> no explicit distinction between interrupts and exceptions.
>>=20
>> The architecture documents have always called it interrupts.  The PEM
>> says it calls them exceptions instead, but they are called interrupts =
in
>> the architecture (and the PEM says that, too).
>>=20
>>> Here is the "The Programming Environments" link:
>>> https://www.nxp.com.cn/docs/en/user-guide/MPCFPE_AD_R1.pdf
>>=20
>> That document is 24 years old.  The architecture is still published,
>> new versions regularly.
>>=20
>>> As far as I know, the values of interrupts or exceptions above are =
defined
>>> explicitly in reference manual or the programming environments.
>>=20
>> They are defined in the architecture.
>>=20
>>> Could
>>> you please provide more details about multiple exceptions with the =
same
>>> interrupts?
>>=20
>> The simplest example is 700, program interrupt.  There are many =
causes
>> for it, including all the exceptions in FPSCR: VX, ZX, OX, UX, XX, =
and
>> VX is actually divided into nine separate cases itself.  There also =
are
>> the various causes of privileged instruction type program interrupts,
>> and  the trap type program interrupt, but the FEX ones are most =
obvious
>> here.
>=20
> Also:
>=20
> * Some interrupts have no corresponding exception (system call and=20
> system call vectored). This is not just semantics or a bug in the ISA
> because it is different from other synchronous interrupts: =
instructions=20
> which cause exceptions (e.g., a page fault) do not complete before=20
> taking the interrupt whereas sc does.
>=20
> * It's quite usual for an exception to not cause an interrupt=20
> immediately (MSR[EE]=3D0, HMEER) or never cause one and be cleared by=20=

> other means (msgclr, mtDEC, mtHMER, etc).
>=20
> * It's possible for an exception to cause different interrupts!
> A decrementer exception usually causes a decrementer interrupt, but it
> can cause a system reset interrupt if the processor was in a power
> saving mode. A data storage exception can cause a DSI or HDSI =
interrupt
> depending on LPCR settings, and many other examples.
>=20
> So I agree with Segher on this. We should use interrupt for =
interrupts,=20
> reduce exception except where we really mean it, and move away from =
vec=20
> and trap (I've got this wrong in the past too I admit). We don't have =
to=20
> do it all immediately, but new code should go in this direction.

Appreciate these details about exceptions and interrupts. Looks like =
interrupt
is the correct term here. I=E2=80=99m glad to create the v3 patch with =
INTERRUPT_
prefix. =20

Regards,
Xiongwei

>=20
> Thanks,
> Nick

