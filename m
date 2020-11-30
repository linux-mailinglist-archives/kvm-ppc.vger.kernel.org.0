Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDABE2C878C
	for <lists+kvm-ppc@lfdr.de>; Mon, 30 Nov 2020 16:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgK3PRV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 30 Nov 2020 10:17:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725859AbgK3PRV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 30 Nov 2020 10:17:21 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUEmxq8134051;
        Mon, 30 Nov 2020 10:16:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=SVunJp4tA4QxqyyebemWUkhMQjF3mk9I7QKpQCzCIYw=;
 b=r/QIno9Xo/xO4H+mXfvE/3pHss07Yvz1UKLT38kW7GQsKEgWLm+SV1H5V13dcMRWS/4j
 7dcqKJ9YY8N3nr5A4Mb1l1gDM544ki/1AEl6QvejV5upE1PKjcAJh2VUcfTnq+XgXwnV
 IGfAEn71H0pI7+oXsW0iaELAQ1Lav6H7WhJ4WtnalD06161VTybOnIEQmQo7lrhezJKO
 9N8k7UPzleTiUy+RLzVngePah2opW8Zg102Yy7EJ5sEyJtBMIxZHP6Oxco+WXkAjXwo7
 EVBEvTGuAJ1ZwSl7Tr/XZhyHt7oLG7qmjEMD0a6FpKf0VeqPY8+Qik0gwjRFyyQF+vYo /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3552u5ryrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:16:22 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AUEplk5146991;
        Mon, 30 Nov 2020 10:16:21 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3552u5ryq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 10:16:21 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AUF94mW008196;
        Mon, 30 Nov 2020 15:16:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 353e68a5p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 15:16:19 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AUFGHwt62914990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 15:16:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF27AAE045;
        Mon, 30 Nov 2020 15:16:16 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45D6BAE051;
        Mon, 30 Nov 2020 15:16:15 +0000 (GMT)
Received: from lep8c.aus.stglabs.ibm.com (unknown [9.40.192.207])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Nov 2020 15:16:15 +0000 (GMT)
Subject: [RFC Qemu PATCH v2 0/2] spapr: nvdimm: Asynchronus flush hcall
 support
From:   Shivaprasad G Bhat <sbhat@linux.ibm.com>
To:     xiaoguangrong.eric@gmail.com, mst@redhat.com, imammedo@redhat.com,
        david@gibson.dropbear.id.au, qemu-devel@nongnu.org,
        qemu-ppc@nongnu.org
Cc:     shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com,
        linux-nvdimm@lists.01.org, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, aneesh.kumar@linux.ibm.com
Date:   Mon, 30 Nov 2020 09:16:14 -0600
Message-ID: <160674929554.2492771.17651548703390170573.stgit@lep8c.aus.stglabs.ibm.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_05:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011300094
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The nvdimm devices are expected to ensure write persistent during power
failure kind of scenarios.

The libpmem has architecture specific instructions like dcbf on power
to flush the cache data to backend nvdimm device during normal writes.

Qemu - virtual nvdimm devices are memory mapped. The dcbf in the guest
doesn't traslate to actual flush to the backend file on the host in case
of file backed vnvdimms. This is addressed by virtio-pmem in case of x86_64
by making asynchronous flushes.

On PAPR, issue is addressed by adding a new hcall to
request for an explicit asynchronous flush requests from the guest ndctl
driver when the backend nvdimm cannot ensure write persistence with dcbf
alone. So, the approach here is to convey when the asynchronous flush is
required in a device tree property. The guest makes the hcall when the
property is found, instead of relying on dcbf.

The first patch adds the necessary asynchronous hcall support infrastructure
code at the DRC level. Second patch implements the hcall using the
infrastructure.

Hcall semantics are in review and not final.

A new device property sync-dax is added to the nvdimm device. When the 
sync-dax is off(default), the asynchronous hcalls will be called.

With respect to save from new qemu to restore on old qemu, having the
sync-dax by default off(when not specified) causes IO errors in guests as
the async-hcall would not be supported on old qemu. The new hcall
implementation being supported only on the new  pseries machine version,
the current machine version checks may be sufficient to prevent
such migration. Please suggest what should be done.

The below demonstration shows the map_sync behavior with sync-dax on & off.
(https://github.com/avocado-framework-tests/avocado-misc-tests/blob/master/memory/ndctl.py.data/map_sync.c)

The pmem0 is from nvdimm with With sync-dax=on, and pmem1 is from nvdimm with syn-dax=off, mounted as
/dev/pmem0 on /mnt1 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)
/dev/pmem1 on /mnt2 type xfs (rw,relatime,attr2,dax=always,inode64,logbufs=8,logbsize=32k,noquota)

[root@atest-guest ~]# ./mapsync /mnt1/newfile    ----> When sync-dax=off
[root@atest-guest ~]# ./mapsync /mnt2/newfile    ----> when sync-dax=on
Failed to mmap  with Operation not supported

---
v1 - https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg06330.html
Changes from v1
      - Fixed a missed-out unlock
      - using QLIST_FOREACH instead of QLIST_FOREACH_SAFE while generating token

Shivaprasad G Bhat (2):
      spapr: drc: Add support for async hcalls at the drc level
      spapr: nvdimm: Implement async flush hcalls


 hw/mem/nvdimm.c            |    1
 hw/ppc/spapr_drc.c         |  146 ++++++++++++++++++++++++++++++++++++++++++++
 hw/ppc/spapr_nvdimm.c      |   79 ++++++++++++++++++++++++
 include/hw/mem/nvdimm.h    |   10 +++
 include/hw/ppc/spapr.h     |    3 +
 include/hw/ppc/spapr_drc.h |   25 ++++++++
 6 files changed, 263 insertions(+), 1 deletion(-)

--
Signature

